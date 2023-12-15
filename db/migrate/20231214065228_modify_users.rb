class ModifyUsers < ActiveRecord::Migration[6.0]
  def change
    # Add the session_token field
    add_column :users, :session_token, :string, null: false

    # Add indices for uniqueness
    add_index :users, :session_token, unique: true
    add_index :users, :username, unique: true

    # Change columns to not nullable
    change_column_null :users, :username, false
    change_column_null :users, :password_digest, false


  end
end
