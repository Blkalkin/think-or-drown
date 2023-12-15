class MarketStocksController < ApplicationController
  def index
    @market_stocks = MarketStock.all
    render json: @market_stocks
  end

  def update_prices
    MarketStock.find_each do |market_stock|
      new_price = market_stock.current_price * rand(0.995..1.005)
      market_stock.update(current_price: new_price.round(2))
    end
    head :ok
  end
end