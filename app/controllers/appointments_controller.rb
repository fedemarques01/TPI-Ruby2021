class AppointmentsController < ApplicationController
  before_action :set_professional
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  # GET /appointments
  def index
    @appointments = @professional.appointments
  end

  # GET /appointments/1
  def show
  end

  # GET /appointments/new
  def new
    @appointment = @professional.appointments.new()
  end

  # GET /appointments/1/edit
  def edit
  end

  # POST /appointments
  def create
    @appointment = @professional.appointments.new(appointment_params)
    if @appointment.save
      redirect_to [@professional,@appointment], notice: 'Appointment was successfully created. :D'
    else
      render :new
    end
  end

  # PATCH/PUT /appointments/1
  def update
    if @appointment.update(appointment_params)
      redirect_to [@professional,@appointment], notice: 'Appointment was successfully updated. :D'
    else
      render :edit
    end
  end

  # DELETE /appointments/1
  def destroy
    @appointment.destroy
    redirect_to professional_appointments_url(@professional), notice: 'Appointment was successfully destroyed. :D'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_professional
      @professional = Professional.find(params[:professional_id])
    end

    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def appointment_params
      params.require(:appointment).permit(:date, :patient_name, :patient_surname, :phone, :notes)
    end
end
