class AddFieldsToStocks < ActiveRecord::Migration[7.1]
  def change
    add_column :stocks, :current_price, :decimal, precision: 10, scale: 2
    add_column :stocks, :quantity, :integer
  end
end
