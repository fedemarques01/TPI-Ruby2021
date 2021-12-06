class ProfessionalsController < ApplicationController
  before_action :check_auth
  before_action :check_role, only: [:edit, :update, :destroy]
  before_action :set_professional, only: [:show, :edit, :update, :destroy]

  # GET /professionals
  def index
    @professionals = Professional.all
  end

  # GET /professionals/1
  def show
  end

  # GET /professionals/new
  def new
    @professional = Professional.new
  end

  # GET /professionals/1/edit
  def edit
  end

  # POST /professionals
  def create
    @professional = Professional.new(professional_params)

    if @professional.save
      redirect_to @professional, notice: 'Professional was successfully created. :D'
    else
      render :new
    end
  end

  # PATCH/PUT /professionals/1
  def update
    if @professional.update(professional_params)
      redirect_to @professional, notice: 'Professional was successfully updated. :D'
    else
      render :edit
    end
  end

  # DELETE /professionals/1
  def destroy
    if @professional.destroy
      notice = 'Professional was successfully destroyed. :D'
    else
      notice = 'The selected professional has appointments. D:'
    end
    redirect_to professionals_url, notice: notice
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_professional
      @professional = Professional.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def professional_params
      params.require(:professional).permit(:name, :surname)
    end

    #Chequeo de autenticacion
    def check_auth
      if session[:user_id].nil?
        flash[:alert] = "You must be logged in to enter this page!!"
        redirect_to login_path
      end
    end
    #Chequeo de que sea admin para borrar y editar
    def check_role
      if current_user.role != "administracion"
        flash[:alert] = "You don't have permission to access to that URL!! You have been redirected to the home page"
        redirect_to root_path
      end
    end
end
