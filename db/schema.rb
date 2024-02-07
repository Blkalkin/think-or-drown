# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_01_29_020215) do
  create_table "portfolios", force: :cascade do |t|
    t.string "stock_ticker", null: false
    t.string "stock_name", null: false
    t.decimal "bought_price", precision: 10, scale: 2, null: false
    t.integer "bought_quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_portfolios_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email"
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "session_token", null: false
    t.decimal "account_total_value"
    t.decimal "account_cash"
    t.decimal "account_stock_value"
    t.index ["session_token"], name: "index_users_on_session_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "watch_lists", force: :cascade do |t|
    t.string "stock_ticker", null: false
    t.string "stock_name", null: false
    t.decimal "current_stock_price", precision: 10, scale: 2
    t.decimal "previous_close", precision: 10, scale: 2
    t.decimal "current_percent_change", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_ticker"], name: "index_watch_lists_on_stock_ticker", unique: true
  end

  add_foreign_key "portfolios", "users"
end
