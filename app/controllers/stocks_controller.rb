class StocksController < ApplicationController
    before_action :require_logged_in
    before_action :set_portfolio
    before_action :set_stock, only: [:sell]
  

    def buy
      market_stock = MarketStock.find_by(ticker_symbol: stock_params[:ticker_symbol])
      if market_stock
        @stock = @portfolio.stocks.find_or_initialize_by(ticker_symbol: market_stock.ticker_symbol)
        @stock.name = market_stock.name
        @stock.quantity ||= 0
        @stock.quantity += stock_params[:quantity].to_i
        @stock.current_price = market_stock.current_price
  
        if @stock.save
          render json: @stock, status: :created
        else
          render json: @stock.errors, status: :unprocessable_entity
        end
      else
        render json: { error: "Stock not found in market stocks" }, status: :not_found
      end
    end
  
    def sell
        quantity_to_sell = params[:quantity].to_i
    
        if quantity_to_sell <= 0
          render json: { error: "Invalid quantity" }, status: :unprocessable_entity
          return
        end
    
        if @stock && @stock.quantity >= quantity_to_sell
          amount_earned = quantity_to_sell * @stock.current_price
          new_quantity = @stock.quantity - quantity_to_sell
          @stock.update!(quantity: new_quantity)
    
    
          @stock.destroy if @stock.quantity.zero?
    
          @portfolio.update!(current_cash: @portfolio.current_cash + amount_earned)
          render json: { message: "Stock sold successfully", current_cash: @portfolio.current_cash, stock_quantity: @stock.quantity }
        else
          render json: { error: "Insufficient stock quantity" }, status: :unprocessable_entity
        end
    end
  
    private
    def set_stock
      @stock = @portfolio.stocks.find(params[:id])
    end
  
    def set_portfolio
      @portfolio = current_user.portfolio
      unless @portfolio
        render json: { error: "Portfolio not found" }, status: :not_found
        return
      end
    end
  
    def stock_params
      params.require(:stock).permit(:name, :ticker_symbol, :quantity)
    end
  end
  