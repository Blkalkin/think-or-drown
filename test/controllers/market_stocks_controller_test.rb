require "test_helper"

class MarketStocksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get market_stocks_index_url
    assert_response :success
  end
end
