# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
market_stocks = [
  { name: "Apple Inc.", ticker_symbol: "AAPL", current_price: 150.50 },
  { name: "Microsoft Corporation", ticker_symbol: "MSFT", current_price: 280.30 },
  { name: "Amazon.com, Inc.", ticker_symbol: "AMZN", current_price: 3300.70 },
  { name: "Tesla, Inc.", ticker_symbol: "TSLA", current_price: 700.40 },
  { name: "Alphabet Inc.", ticker_symbol: "GOOGL", current_price: 2300.80 },
  { name: "Facebook, Inc.", ticker_symbol: "FB", current_price: 270.50 },
  { name: "Berkshire Hathaway Inc.", ticker_symbol: "BRK.A", current_price: 412000.00 },
  { name: "Visa Inc.", ticker_symbol: "V", current_price: 210.65 },
  { name: "Johnson & Johnson", ticker_symbol: "JNJ", current_price: 160.20 },
  { name: "Walmart Inc.", ticker_symbol: "WMT", current_price: 140.40 },
  { name: "JPMorgan Chase & Co.", ticker_symbol: "JPM", current_price: 155.00 },
  { name: "Mastercard Incorporated", ticker_symbol: "MA", current_price: 350.90 },
  { name: "Procter & Gamble Co", ticker_symbol: "PG", current_price: 130.25 },
  { name: "NVIDIA Corporation", ticker_symbol: "NVDA", current_price: 540.60 },
  { name: "UnitedHealth Group Incorporated", ticker_symbol: "UNH", current_price: 410.80 },
  { name: "Home Depot, Inc.", ticker_symbol: "HD", current_price: 310.50 },
  { name: "Verizon Communications Inc.", ticker_symbol: "VZ", current_price: 58.70 },
  { name: "The Boeing Company", ticker_symbol: "BA", current_price: 220.30 },
  { name: "Coca-Cola Company", ticker_symbol: "KO", current_price: 54.35 },
  { name: "Pfizer Inc.", ticker_symbol: "PFE", current_price: 38.90 }
]

market_stocks.each do |stock|
  MarketStock.create!(stock)
end
