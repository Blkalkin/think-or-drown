class AddWatchlist < ActiveRecord::Migration[7.1]
  def change
    create_table :watch_lists do |t|
      t.string :stock_ticker, null: false
      t.string :stock_name, null: false
      t.decimal :current_stock_price, precision: 10, scale: 2
      t.decimal :previous_close, precision: 10, scale: 2
      t.decimal :current_percent_change, precision: 5, scale: 2

      t.timestamps
    end
    add_index :watch_lists, :stock_ticker, unique: true
  end
end
