class AppointmentsUtils
    def self.get_hash_week(week_start,week_end)
        week = Hash[(week_start.to_date..week_end.to_date)
            .map { |date| date.to_s}
            .collect{ |elem| [elem, []] }]
    end

    def self.get_appointments_per_day(week,appointments)
        appointments.each do |appointment|
            appointment_date = appointment.date.to_date.to_s
            if week.key?(appointment_date)
                week[appointment_date].append(appointment)
            end
        end
    end
end