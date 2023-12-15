class SessionsController < ApplicationController
  before_action :require_logged_in, only: :destroy
  before_action :require_logged_out, only: :create

  def create
    username = params[:username]
    password = params[:password]
    @user = User.find_by_credentials(username, password)
    if @user
      login!(@user)
      render 'api/users/info'
    else
      render json: { errors: ['Invalid credentials'] }, status: 401
    end
  end

  def destroy
    logout!
    head :no_content
  end
end