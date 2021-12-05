module AppointmentsHelper
    def display_date(appointment)
        I18n.l(appointment.date, format: :long)
    end
end
