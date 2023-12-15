class CreateMarketStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :market_stocks do |t|
      t.string :name
      t.string :ticker_symbol
      t.decimal :current_price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
