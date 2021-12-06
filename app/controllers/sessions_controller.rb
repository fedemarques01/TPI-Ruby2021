class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:notice] = "Logged in successfully. :D"
      redirect_to root_path
    else
      flash.now[:alert] = "Username or password is incorrect"
      render 'new'
    end
  end

  def destroy
    # Remove the user id from the session
    @_current_user = session[:current_user_id] = nil
    flash[:notice] = "Logged out successfully."
    redirect_to login_path
  end
end
