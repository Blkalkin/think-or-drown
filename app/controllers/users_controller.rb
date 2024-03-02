require 'net/http'
require 'uri'
require 'json'

class UsersController < ApplicationController
  wrap_parameters include: User.attribute_names + ['password']

  before_action :require_logged_out, only: :create

    def create
      @user = User.new(user_params)
      if @user.save
        @user.create_portfolio
        login!(@user)
        render :info
      else
        render json: @user.errors, status: 422
      end
    end

    def get_user_info
      @user = User.find(params[:id])
      if @user
        render json: @user
      else
        render json: { error: 'User not found' }, status: :not_found
      end
    end
    
    def manage_portfolio_transaction #need to subtract from cash when buying and add to cash when selling
      @user = User.find(params[:id])
  
      if buying_stock? && !sufficient_funds?
        render json: { error: 'Insufficient funds.' }, status: :unprocessable_entity
        return
      end
  
      existing_portfolio = @user.portfolios.find_by(stock_ticker: portfolio_params[:stock_ticker])
      existed = false
  
      if existing_portfolio
        process_existing_portfolio(existing_portfolio)
        existed = true
      else
        create_new_portfolio
      end

      update_current_value
      update_total_value
    end
    

    def update_current_cash
      @user = User.find(params[:id])
      cash_to_add = params[:current_cash]
      current_cash = @user.account_cash

    
      if @user.update(account_cash: current_cash + cash_to_add)
        update_current_value
        update_total_value
        # Handle successful update
        render json: { message: 'Account cash updated successfully.', account_cash: @user.account_cash }, status: :ok
      else
        # Handle failure
        render json: @user.errors, status: :unprocessable_entity
      end
    end


    def get_most_recent_prices
      @user = User.find(params[:id])
      @user.portfolios.each do |portfolio|
        url = construct_query(portfolio.stock_ticker)
        response = Net::HTTP.get(URI.parse(url))
        data = JSON.parse(response)
  
        # Assuming the latest price is the closing price of the last available aggregate
        last_price = data['results'].last['c'] rescue nil
        # Update the portfolio with the last price
        portfolio.update(bought_price: last_price) if last_price
      end
  
    end
    
    def portfolio_data
      @user = User.find(params[:id])
  
      # Update the most recent prices
      get_most_recent_prices
  
      # Fetch updated portfolio data
      updated_portfolios = @user.portfolios
  
      # Send the data to the frontend
      render json: updated_portfolios
    end
    
    private
    def process_existing_portfolio(existing_portfolio)
      new_quantity = existing_portfolio.bought_quantity + portfolio_params[:bought_quantity].to_i
  
      if new_quantity > 0
        update_portfolio(existing_portfolio, new_quantity)
      elsif new_quantity == 0
        sell_cash_update
        existing_portfolio.destroy
        render json: { message: 'Portfolio transaction was successfully deleted.' }, status: :ok
      else
        render json: { error: 'Invalid quantity. Cannot reduce below zero.' }, status: :unprocessable_entity
      end
    end
  
    def update_portfolio(existing_portfolio, new_quantity)
      if portfolio_params[:bought_quantity].to_i > 0
        buy_cash_update
        # Cost averaging
        total_cost = existing_portfolio.bought_price * existing_portfolio.bought_quantity
        total_cost += portfolio_params[:bought_price].to_f * portfolio_params[:bought_quantity].to_i
        new_average_cost = total_cost / new_quantity
        existing_portfolio.update(bought_price: new_average_cost, bought_quantity: new_quantity)
      else
        sell_cash_update
        # Reduction
        existing_portfolio.update(bought_quantity: new_quantity)
        @user.account_cash += portfolio_params[:bought_quantity].to_i.abs * portfolio_params[:bought_price].to_f
      end
      render json: existing_portfolio, status: :ok
    end
  
    def create_new_portfolio
      if portfolio_params[:bought_quantity].to_i > 0
        new_portfolio = @user.portfolios.create(portfolio_params)
        if new_portfolio.persisted?
          render json: new_portfolio, status: :created
        else
          render json: new_portfolio.errors, status: :unprocessable_entity
        end
      else
        render json: { error: 'Invalid quantity. Cannot create transaction with negative quantity.' }, status: :unprocessable_entity
      end
    end
  
    def buying_stock?
      portfolio_params[:bought_quantity].to_i > 0
    end
  
    def sufficient_funds?
      total_purchase_cost = portfolio_params[:bought_price].to_f * portfolio_params[:bought_quantity].to_i
      @user.account_cash.to_f >= total_purchase_cost
    end

    def buy_cash_update
      new_cash = @user.account_cash - (portfolio_params[:bought_price].to_f * portfolio_params[:bought_quantity].to_i)
      unless @user.update(account_cash: new_cash)
        return
      end
    end

    def sell_cash_update
      new_cash = @user.account_cash + (portfolio_params[:bought_price].to_f * portfolio_params[:bought_quantity].to_i * -1)
      unless @user.update(account_cash: new_cash)
        return
      end
    end

    def update_current_value
      @user = User.find(params[:id])
      
      # Calculate the total value by summing up (quantity * bought_price) for each portfolio entry
      new_value = @user.portfolios.sum { |portfolio| portfolio.bought_quantity * portfolio.bought_price }
      
      # Update user's current value
      if @user.update(account_stock_value: new_value)
        # Log success or handle it internally
      else
        # Log failure or handle it internally
      end
    end
  
    def update_total_value
      @user = User.find(params[:id])
      
      # Calculate the new total value
      new_total_value = @user.account_cash + @user.account_stock_value
      
      # Update the user's account_total_value
      if @user.update(account_total_value: new_total_value)
        # Log success or handle it internally
      else
        # Log failure or handle it internally
      end
    end

    def user_params
      params.require(:user).permit(:username, :email, :password, :current_cash)
    end

    def portfolio_params
      params.require(:portfolio).permit(:stock_ticker, :stock_name, :bought_price, :bought_quantity)
    end

    def construct_query(ticker_symbol)
      apiKey = '2G0EFUgJp5XxRAa2unpWyJ3oqqnKrJHa'
      now = Time.now.utc
      market_open_time = now.change(hour: 13, min: 30) # 9:30 AM ET in UTC
      market_close_time = now.change(hour: 20, min: 0) # 4:00 PM ET in UTC
  
      is_market_open = now.between?(market_open_time, market_close_time) && now.wday.between?(1, 5)
  
      from, to = if is_market_open
                   [15.minutes.ago.utc.strftime('%Y-%m-%d'), now.strftime('%Y-%m-%d')]
                 else
                   date = (now.wday == 0 || now.wday == 6 || now < market_open_time) ? now - 1.day : now
                   date -= 1.day while date.wday == 0 || date.wday == 6
                   [date.strftime('%Y-%m-%d'), date.strftime('%Y-%m-%d')]
                 end
  
      "https://api.polygon.io/v2/aggs/ticker/#{ticker_symbol}/range/1/minute/#{from}/#{to}?apiKey=#{apiKey}"
    end

  end
  