class Portfolio < ApplicationRecord
  belongs_to :user
  has_many :stocks

  def total_value
    stocks.sum(&:current_value) + current_cash
  end
end
