module Polycon
    module Models
        class Professionals

            attr_accessor :name
            def initialize(name)
                @name = name
            end
            
            def self.exist?(name)
                #Devuelve true o false dependiendo de que exista una carpeta con ese profesional en el sistema
                Dir.exist?("#{Polycon::Utils.path}/#{name}")
            end

            def create_professional_folder
                #crea una carpeta con el nombre del profesional y devuelve true si fue creada o false si ocurrio un error
                Dir.mkdir("#{Polycon::Utils.path}/#{name}")
                rescue
                    false
                else
                    true
            end

            def delete
                #Elimina la carpeta del profesional, devuelve true si fue eliminada o false si posee turnos
                Dir.delete("#{Polycon::Utils.path}/#{name}")
                rescue SystemCallError
                    false
                else
                    true
            end

            def self.list_professionals
                #Devuelve un arreglo con el nombre de todos los profesionales creados en el sistema, si no hay profesionales es un arreglo vacio
                Dir.children(Polycon::Utils.path)
            end

            def rename(newName)
                #Modifica el nombre de la carpeta del profesional por el nuevo nombre
                File.rename("#{Polycon::Utils.path}/#{name}", "#{Polycon::Utils.path}/#{newName}")
                rescue
                    false
                else
                    true
            end

            def list_appointments(date)
                #Muestra en pantalla todos los turnos del profesional, opcionalmente filtrados por fecha, si no tiene turnos lo informa en pantalla
                turnos = []
                Dir.children("#{Polycon::Utils.path}/#{name}").each { |appointment|
                    if ((appointment.split("_")[0] == date) || date.nil?)
                        turnos << Appointments.get_appointment(appointment.delete(".paf"),@name)
                    end
                    }
                turnos
            end

            def cancel_appointments
                #Cancela todos los turnos del profesional
                Dir.each_child("#{Polycon::Utils.path}/#{name}") { |appointment| 
                    File.delete("#{Polycon::Utils.path}/#{name}/#{appointment}")
                }
            end
        end
    end
end

