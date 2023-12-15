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

ActiveRecord::Schema[7.1].define(version: 2023_12_15_083749) do
  create_table "market_stocks", force: :cascade do |t|
    t.string "name"
    t.string "ticker_symbol"
    t.decimal "current_price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "portfolios", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "current_cash", precision: 10, scale: 2, default: "10000.0", null: false
    t.decimal "total_value", precision: 10, scale: 2, default: "10000.0", null: false
    t.index ["user_id"], name: "index_portfolios_on_user_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.integer "portfolio_id", null: false
    t.string "name"
    t.string "ticker_symbol"
    t.decimal "purchase_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "current_price", precision: 10, scale: 2
    t.integer "quantity"
    t.index ["portfolio_id"], name: "index_stocks_on_portfolio_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email"
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "session_token", null: false
    t.index ["session_token"], name: "index_users_on_session_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "portfolios", "users"
  add_foreign_key "stocks", "portfolios"
end
