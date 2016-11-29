class SessionsController < ApplicationController
  def create
    user = User.find_by_name_and_pw(
      params[:user][:name],
      params[:user][:password]
    )

    if user
      log_in!(user)
      redirect_to users_url
    else
      flash.now[:errors] = ["Invalid credentials"]
      render :new
    end
  end

  def new
  end

  def destroy
    log_out!
    redirect_to login_url
  end
end
