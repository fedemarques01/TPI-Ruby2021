class Appointment < ApplicationRecord
  belongs_to :professional
  validates :patient_name, :patient_surname, :date, :phone, presence: true
  validates :phone, numericality: { only_integer: true }
end
