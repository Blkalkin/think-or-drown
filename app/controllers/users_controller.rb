class UsersController < ApplicationController
  wrap_parameters include: User.attribute_names + ['password']

  before_action :require_logged_out, only: :create

    def create
      @user = User.new(user_params)
      if @user.save
        @user.create_portfolio
        login!(@user)
        render :info
      else
        render json: @user.errors, status: 422
      end
    end


    private
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

  end
  