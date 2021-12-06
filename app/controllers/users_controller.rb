class UsersController < ApplicationController
  before_action :check_auth_and_role
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: 'User was successfully created. :D'
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated. :D'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed. :D'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation,:role_id)
    end

    #Chequea que tenga rol admin y este logueado
    def check_auth_and_role()
      if session[:user_id].nil?
        flash[:alert] = "You must be logged in to enter this page!!"
        redirect_to login_path
      elsif current_user.role.name != "administracion"
        flash[:alert] = "You don't have permission to access to that URL!! You have been redirected to the home page"
        redirect_to root_path
      end 
    end
end
