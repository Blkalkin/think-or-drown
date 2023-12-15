class AddDetailsToPortfolios < ActiveRecord::Migration[7.1]
  def change
    add_column :portfolios, :current_cash, :decimal, precision: 10, scale: 2, default: 10000.0, null: false
    add_column :portfolios, :total_value, :decimal, precision: 10, scale: 2, default: 10000.0, null: false
  end
end
