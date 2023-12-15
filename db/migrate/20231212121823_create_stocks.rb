class CreateStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.references :portfolio, null: false, foreign_key: true
      t.string :name
      t.string :ticker_symbol
      t.decimal :purchase_price

      t.timestamps
    end
  end
end
