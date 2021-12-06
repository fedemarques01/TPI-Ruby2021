class ExportController < ApplicationController
  before_action :check_auth
  before_action :set_professional, only:[:export_professional]

  def export_all
  end

  def export_professional
    if params.include?(:export) && !params[:export][:date].blank?
      #Me guardo los datos del formulario
      date = params[:export][:date].to_date()
      week = params[:export][:week].to_i
      datetime = Time.zone.local(date.year,date.month,date.day)

      #Si marco la semana
      if week == 1
        week_start = datetime.beginning_of_week
        week_end = datetime.end_of_week
        appointments = Appointment.where("professional_id = ?", @professional.id).where("date BETWEEN ? AND ?", week_start.beginning_of_day, week_end.end_of_day).all.order('date ASC') #obtengo todos los turnos de la semana
        #genero un hash con dia => arreglo vacio
        week = AppointmentsUtils.get_hash_week(week_start,week_end)
      else
        appointments = Appointment.where("professional_id = ?", @professional.id).where("date BETWEEN ? AND ?", datetime.beginning_of_day, datetime.end_of_day).all.order('date ASC') #obtengo todos los turnos del dia
        week = { datetime.to_date.to_s => [] }
      end

      #cargo el hash con los appointments de cada dia
      AppointmentsUtils.get_appointments_per_day(week,appointments)
      send_data Export.export_pdf(week), filename:'schedule_professional.pdf', type: "application/pdf", disposition: :attachment
    else
      render 'export_professional'
    end
  end

  private
    def set_professional
      @professional = Professional.find(params[:professional_id])
    end

    #Chequeo de autenticacion
    def check_auth
      if session[:user_id].nil?
        flash[:alert] = "You must be logged in to enter this page!!"
        redirect_to login_path
      end
    end
end
