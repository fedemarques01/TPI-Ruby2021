class Appointment < ApplicationRecord
  belongs_to :professional
  validates :patient_name, :patient_surname, :date, :phone, presence: true
  validates :phone, numericality: { only_integer: true }
  validate :appointment_hour, :hour_availability

  #valida que el turno comienze en el minuto 0 o 30 y este dentro del horario de apertura del policonsultorio
  def appointment_hour
    if date.present? #Si ingrese una fecha
      errors.add(:date, "minutes of the appointment must be 0 or 30") unless [0,30].include? date.min
      errors.add(:date, "hour must be between 9 and 19") unless (9..19).include? date.hour
    end
  end

  #valida que el horario del turno no coincida con otro turno ya existente para ese profesional
  def hour_availability
    if date.present?
      existing_appointment = Appointment.where("date = ? and professional_id = ?", date.to_datetime, professional_id).first
      if existing_appointment
        errors.add(:date, " : The professional already has an appointment on that date and hour") unless id == existing_appointment.id
      end
    end
  end

  #devuelve info del turno en un formato apto para grillas
  def schedule_format()
    "Prof. #{professional} - #{patient_surname} #{patient_name}"
  end
end
