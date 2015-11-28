class UsersController < ApplicationController
before_action :require_login!, only: [:index, :show]
  def create
    @user = User.new(user_params)

    if @user.save
      log_in!(@user)
      redirect_to users_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  #sign up page
  def new
    @user = User.new
  end

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :edit
    end
  end

  def show
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :taste)
  end
end
