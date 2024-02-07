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

    def manage_portfolio_transaction
      @user = User.find(params[:id]) # Assuming you pass the user's ID in the request
      
      
      # Find an existing portfolio entry with the same stock ticker
      
      existing_portfolio = @user.portfolios.find_by(stock_ticker: portfolio_params[:stock_ticker])

      # Check if the transaction is a purchase and if there are sufficient funds
      if portfolio_params[:bought_quantity].to_i > 0
        total_purchase_cost = portfolio_params[:bought_price].to_f * portfolio_params[:bought_quantity].to_i
        if @user.account_cash.to_f < total_purchase_cost.to_f
          render json: { error: 'Insufficient funds.' }, status: :unprocessable_entity
          return # Stop further processing
        end
      end
    
      if existing_portfolio
        # Calculate the new total quantity
        new_quantity = existing_portfolio.bought_quantity + portfolio_params[:bought_quantity].to_i
    
        if new_quantity > 0
          if portfolio_params[:bought_quantity].to_i > 0
            # Perform cost averaging for positive quantity
            total_cost = existing_portfolio.bought_price * existing_portfolio.bought_quantity
            total_cost += portfolio_params[:bought_price].to_f * portfolio_params[:bought_quantity].to_i
            new_average_cost = total_cost / new_quantity
            updated_attributes = { bought_price: new_average_cost, bought_quantity: new_quantity }
          else
            # Simply reduce the quantity for negative quantity
            updated_attributes = { bought_quantity: new_quantity }

            # Update user cash
            @user.account_cash += portfolio_params[:bought_quantity] * portfolio_params[:bought_price] * -1
          end
    
          # Update existing portfolio
          if existing_portfolio.update(updated_attributes)
            render json: existing_portfolio, status: :ok
          else
            render json: existing_portfolio.errors, status: :unprocessable_entity
          end
        elsif new_quantity == 0
          # Delete the portfolio transaction if quantity reaches 0
          existing_portfolio.destroy
          render json: { message: 'Portfolio transaction was successfully deleted.' }, status: :ok
        else
          # Handle case where new quantity would be negative
          render json: { error: 'Invalid quantity. Cannot reduce below zero.' }, status: :unprocessable_entity
        end
      else
        # Create a new portfolio transaction if no existing entry with same ticker
        # and if incoming quantity is positive
        if portfolio_params[:bought_quantity].to_i > 0
          new_portfolio = @user.portfolios.create(portfolio_params)
          if new_portfolio.persisted?
            render json: new_portfolio, status: :created
          else
            render json: new_portfolio.errors, status: :unprocessable_entity
          end
        else
          # Handle case where trying to create a transaction with negative quantity
          render json: { error: 'Invalid quantity. Cannot create transaction with negative quantity.' }, status: :unprocessable_entity
        end
      end
      update_current_value
      update_total_value
    end
    
    def update_current_value
      @user = User.find(params[:id])
    
      # Calculate the total value by summing up (quantity * bought_price) for each portfolio entry
      new_value = @user.portfolios.sum { |portfolio| portfolio.bought_quantity * portfolio.bought_price }
    
      # Update user's current value
      if @user.update(account_stock_value: new_value)
        # Handle successful update
        render json: { message: 'Current value updated successfully.', account_stock_value: new_value }, status: :ok
      else
        # Handle failure
        render json: @user.errors, status: :unprocessable_entity
      end
    end
    

    def update_current_cash
      @user = User.find(params[:id])
      new_cash_value = params[:current_cash]
    
      if @user.update(account_cash: new_cash_value)
        # Handle successful update
        render json: { message: 'Account cash updated successfully.', account_cash: new_cash_value }, status: :ok
      else
        # Handle failure
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def update_total_value
      @user = User.find(params[:id])
    
      # Calculate the new total value
      new_total_value = @user.account_cash + @user.account_stock_value
    
      # Update the user's account_total_value
      if @user.update(account_total_value: new_total_value)
        # Handle successful update
        render json: { message: 'Total value updated successfully.', account_total_value: new_total_value }, status: :ok
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
        portfolio.update(current_price: last_price) if last_price
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
  