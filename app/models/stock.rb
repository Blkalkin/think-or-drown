class Stock < ApplicationRecord
  belongs_to :portfolio 

  def current_value
    quantity * current_price
  end

end
