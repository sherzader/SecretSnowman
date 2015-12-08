class UsersController < ApplicationController
before_filter :require_login!, only: [:index, :show, :edit, :update]
helper_method :default_taste

  def create
    @user = User.new(user_params)
    @user.taste = default_taste

    if @user.save
      log_in!(@user)

      UserMailer.welcome_email(@user).deliver_later

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
      redirect_to edit_user_url(@user)
    else
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :taste)
  end
end
