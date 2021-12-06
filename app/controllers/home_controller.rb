class HomeController < ApplicationController
  def index
    if session[:user_id].nil?
      flash[:alert] = "You must be logged to access to this page"
      redirect_to login_path
    end
  end
end
