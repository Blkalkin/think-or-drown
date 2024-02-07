class AddPortfolio < ActiveRecord::Migration[7.1]
  def change
    create_table :portfolios do |t|
      t.string :stock_ticker, null: false
      t.string :stock_name, null: false
      t.decimal :bought_price, precision: 10, scale: 2, null: false
      t.integer :bought_quantity, null: false

      t.timestamps
    end
  end
end
