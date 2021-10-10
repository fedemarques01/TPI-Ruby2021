module Polycon
  module Commands
    module Appointments
      class Create < Dry::CLI::Command
        desc 'Create an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: true, desc: "Patient's name"
        option :surname, required: true, desc: "Patient's surname"
        option :phone, required: true, desc: "Patient's phone number"
        option :notes, required: false, desc: "Additional notes for appointment"

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name=Carlos --surname=Carlosi --phone=2213334567'
        ]

        def call(date:, professional: "", name: "", surname: "", phone: "", notes: nil)
          Utils.check_polycon_exists #verificamos que polycon exista

          #validado de parametros
          validation_result = Utils.validate_options(professional: professional, name: name,surname: surname,phone: phone) #se guarda el resultado de validar los parametros en una variable para no llamarlo 2 veces
          if not Utils.valid_date?(date) #reviso que la fecha ingresada sea correcta
            warn "ERROR: La fecha ingresada no es correcta, asegurese que este en formato 'AAAA-MM-DD_HH-II'"
          elsif not validation_result.empty? #reviso que el resto de parametros obligatorios recibidos sean validos
            warn "#{validation_result}ERROR: Los datos recibidos para el turno no son correctos\nEjemplo de uso: ''2021-09-16_13-00' --professional='Alma Estevez' --name=Carlos --surname=Carlosi --phone=2213334567'"
          elsif not Models::Professionals.exist?(professional) #reviso que el profesional no exista
            warn "ERROR: No se encontró el profesional ingresado"
          elsif Models::Appointments.exist?(date,professional) #reviso que el turno para ese profesional no exista
            warn "ERROR: Ya existe el turno para el profesional #{professional} el dia #{date}"
          else #Los campos ingresados son correctos
            appointment = Models::Appointments.new(date,professional,surname,name,phone,notes)
            puts appointment.create_file
          end
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show details for an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Shows information for the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional: "")
          Utils.check_polycon_exists
          #validacion de que el profesional y la fecha existen
          if Utils.blank_string?(professional) or not Models::Professionals.exist?(professional) #reviso si existe el profesional
            warn "ERROR: El profesional #{professional} no existe en el sistema"
          elsif Utils.blank_string?(date) or not Models::Appointments.exist?(date,professional) #reviso que si existe el turno para el profesional
            warn "ERROR: El turno del dia #{date} del profesional #{professional} no existe en el sistema"
          else #se pueden mostrar los detalles del turno
            appointment = Models::Appointments.get_appointment(date,professional)
            appointment.show #muestra los datos del turno
          end
          #warn "TODO: Implementar detalles de un turno con fecha '#{date}' y profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end

      class Cancel < Dry::CLI::Command
        desc 'Cancel an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Cancels the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional: "")
          Utils.check_polycon_exists
          #validado de parametros
          if Utils.blank_string?(professional) or not Models::Professionals.exist?(professional) #reviso si existe el profesional
            warn "ERROR: El profesional #{professional} no existe en el sistema"
          elsif Utils.blank_string?(date) or not Models::Appointments.exist?(date,professional) #reviso que si existe el turno para el profesional
            warn "ERROR: El turno del dia #{date} del profesional #{professional} no existe en el sistema"
          else #se puede intentar eliminar el turno
            appointment = Models::Appointments.get_appointment(date,professional)
            puts appointment.cancel #muestro el mensaje que devuelve el eliminar un turno
          end
        end
      end

      class CancelAll < Dry::CLI::Command
        desc 'Cancel all appointments for a professional'

        argument :professional, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez" # Cancels all appointments for professional Alma Estevez',
        ]

        def call(professional:,**)
          Utils.check_polycon_exists
          if Utils.blank_string?(professional)
            warn "ERROR: El profesional no puede ser una cadena vacia"
          elsif not Models::Professionals.exist?(professional)
            warn "ERROR: El profesional no existe en el sistema"
          else
            profesional = Models::Professionals.new(professional)
            puts profesional.cancel_appointments
          end
          #warn "TODO: Implementar borrado de todos los turnos de la o el profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end

      class List < Dry::CLI::Command
        desc 'List appointments for a professional, optionally filtered by a date'

        argument :professional, required: true, desc: 'Full name of the professional'
        option :date, required: false, desc: 'Date to filter appointments by (should be the day)'

        example [
          '"Alma Estevez" # Lists all appointments for Alma Estevez',
          '"Alma Estevez" --date="2021-09-16" # Lists appointments for Alma Estevez on the specified date'
        ]

        def call(professional:, date: nil)
          Utils.check_polycon_exists
          if Utils.blank_string?(professional)
            warn "ERROR: El profesional no puede ser una cadena vacia"
          elsif not Models::Professionals.exist?(professional)
            warn "ERROR: El profesional no existe en el sistema"
          else
            profesional = Models::Professionals.new(professional)
            profesional.list_appointments(date)
          end

          #warn "TODO: Implementar listado de turnos de la o el profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end

      class Reschedule < Dry::CLI::Command
        desc 'Reschedule an appointment'

        argument :old_date, required: true, desc: 'Current date of the appointment'
        argument :new_date, required: true, desc: 'New date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" "2021-09-16 14:00" --professional="Alma Estevez" # Reschedules appointment on the first date for professional Alma Estevez to be now on the second date provided'
        ]

        def call(old_date:, new_date:, professional:)
          warn "TODO: Implementar cambio de fecha de turno con fecha '#{old_date}' para que pase a ser '#{new_date}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit information for an appointments'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: false, desc: "Patient's name"
        option :surname, required: false, desc: "Patient's surname"
        option :phone, required: false, desc: "Patient's phone number"
        option :notes, required: false, desc: "Additional notes for appointment"

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" # Only changes the patient\'s name for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" --surname="New surname" # Changes the patient\'s name and surname for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --notes="Some notes for the appointment" # Only changes the notes for the specified appointment. The rest of the information remains unchanged.',
        ]

        def call(date:, professional:, **options)
          warn "TODO: Implementar modificación de un turno de la o el profesional '#{professional}' con fecha '#{date}', para cambiarle la siguiente información: #{options}.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end
    end
  end
end
