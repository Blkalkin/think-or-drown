class ModifyUserAddValue < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :account_total_value, :decimal
    add_column :users, :account_cash, :decimal
    add_column :users, :account_stock_value, :decimal
  end
end
