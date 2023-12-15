class MarketStock < ApplicationRecord
    validates :name, presence: true
    validates :ticker_symbol, presence: true, uniqueness: true
  

    validates :current_price, numericality: { greater_than_or_equal_to: 0 }
  
end
  