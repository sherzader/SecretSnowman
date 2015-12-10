class UsersController < ApplicationController
before_filter :require_login!, only: [:index, :show, :edit, :update]

  def create
    @user = User.new(user_params)

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

    # might need to delete when secret snowmen are assigned
    unless params[:user_id].nil?
      flash.now[:errors] = ["Secret Snowmen have not yet been assigned - but thanks for checking eager beaver!"]
      flash.now[:errors] << []
      flash.now[:errors] << ["In the meantime, feel free to check out the wish lists of your classmates:"]
    end
  end

  def edit
    @user = User.find(params[:id])

    if @user.id != current_user.id
      flash.now[:errors] = ["Bad elf!  You cannot edit someone else's: profile!"]
    end
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
    params.require(:user).permit(:name, :email, :password, :taste, :secretsnowman_id)
  end
end
