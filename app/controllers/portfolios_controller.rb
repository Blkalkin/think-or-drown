class PortfoliosController < ApplicationController
    before_action :require_logged_in
    before_action :set_portfolio, only: [:show]
  
    # GET /portfolios/1
    def show
      render json: { portfolio: @portfolio, total_value: @portfolio.total_value, stocks: @portfolio.stocks }
    end
  
    private
  
    def set_portfolio
      @portfolio = current_user.portfolio
    end
  end