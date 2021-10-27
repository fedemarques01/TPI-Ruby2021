module Polycon
    module Models
        class Appointments
            
            attr_accessor :date ,:details, :professional

            def initialize(date, professional,surname,name, phone ,notes=nil)
                @date = date
                @professional = professional
                @details = {surname: surname,name: name, phone: phone}
                details["notes"] = notes unless notes.nil?
            end

            def self.exist?(date, professional)
                #retorna true o false si existe un turno con las caracteristicas recibidas por parametro
                File.exist?("#{Polycon::Utils.path}/#{professional}/#{date}.paf")
            end

            def self.get_appointment(date, professional)
                #obtiene una instancia appointment a partir de un archivo existente
                array = []
                File.open("#{Polycon::Utils.path}/#{professional}/#{date}.paf","r") do |file|
                    file.each { |line| array << line.chomp }
                end
                new(date, professional,*array)
            end

            def self.list_all(date,professional)
                #metodo que genera un arreglo con todos los turnos del sistema en una fecha especifica, opcionalmente filtrados por un profesional, sera un arreglo vacio si no hay turnos
                if professional #caso donde recibo un profesional
                    prof = Professionals.new(professional)
                    prof.list_appointments(date) #genero un arreglo con los turnos del profesional
                else 
                    Professionals.list_professionals.inject([]) do |turnos,prof| #recorro todos los profesionales
                        pr = Professionals.new(prof)
                        turnos.concat(pr.list_appointments(date)) #guardo los turnos del profesional en un arreglo
                    end
                end
            end

            def self.list_all_week(start_date,professional)
                #metodo que retorna un hash con un arreglo de turnos por cada uno de los 7 dias siguientes a la fecha recibida por parametro, opcionalmente filtrados por profesional
                (start_date..(start_date+6)).inject({}) { |appointments, date|
                    appointments[date.to_s] = list_all(date.to_s,professional)
                    appointments
                }
            end

            def my_path
                #devuelve la ruta donde se encuentra ubicado el turno, por ejemplo /home/.polycon/Alma Estevez
                "#{Polycon::Utils.path}/#{professional}"
            end

            def save_file
                #guarda en un archivo .paf los datos del turno
                File.open("#{my_path}/#{date}.paf", "w") do |file| 
                    details.values.each { |value| file.puts "#{value}"}
                end
            end

            def show
                #imprime en pantalla los datos de un turno formateados de forma nombre : valor
                details.each {|key,value| puts "#{key} : #{value}"}
            end

            def to_s
                #metodo para retornar una representacion del turno , esta representacion posee el nombre y apellido del paciente y el profesional
                "Prof. #{professional}\nPaciente #{details[:surname]} #{details[:name]}"
            end

            def rename(new_date)
                #cambia el nombre del archivo por la fecha recibida por parametro
                File.rename("#{my_path}/#{date}.paf","#{self.my_path}/#{new_date}.paf")
            end

            def edit_file(**fields)
                #Recibe una cantidad variable de atributos en forma de hash y edita los campos del archivo que se reciban, luego sobreescribe los datos del archivo con la nueva informacion
                fields.each { |key,value| details[key] = value }
                save_file
            end

            def cancel
                #elimina el archivo correspondiente al turno
                File.delete("#{my_path}/#{date}.paf")
            end
        end
    end
end
