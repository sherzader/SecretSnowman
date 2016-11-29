class UsersController < ApplicationController
before_filter :require_login!, only: [:index, :show, :edit, :update]

  def create
    @user = User.new(user_params)
    @user.email ||= "n/a"

    if @user.save
      log_in!(@user)
      flash[:errors] = ["Do not forget to update your wish list."]
      flash[:errors] << ["Go to 'My Profile' to do so."]
      redirect_to users_url
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def new
    redirect_to users_url if current_user
    @user = User.new
  end

  def index
    @users = User.where(group: current_user.group)

    unless params[:user_id].nil?
      flash.now[:errors] = ["Secret Snowmen have not yet been assigned - but thanks for checking eager beaver!"]
      flash.now[:errors] << ["In the meantime, feel free to check out the wish lists of your team:"]
    end
  end

  def edit
    @user = User.find(params[:id])

    if @user.id != current_user.id
      flash.now[:errors] = ["Bad elf!  You cannot edit someone else's profile!"]
      HackingAttempt.create(user_id: current_user.id, description: "Edit someone else's profile")
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to user_url(@user)
    else
      render :edit
    end
  end

  def show
    if params[:user_id] && params[:user_id].to_i != current_user.id
      flash[:errors] = ['Bad elf!  You cannot view another person\'s secret snowman assignment']
      HackingAttempt.create(user_id: current_user.id, description: "View someone else's secret snowman")
      redirect_to users_url
    elsif params[:user_id] && params[:id].to_i != current_user.secretsnowman_id
      flash[:errors] = ['Nice try buddy!  If you want to view another participants wishlist, simply click on their name below.']
      HackingAttempt.create(user_id: current_user.id, description: "View nested show page")
      redirect_to users_url
    else
      @user = User.find(params[:id])
      render :show
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :taste, :secretsnowman_id, :group)
  end
end
