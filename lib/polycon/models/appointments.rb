module Polycon
    module Models
        class Appointments
            
            attr_accessor :date ,:details, :professional

            def initialize(date, professional,surname,name, phone ,notes=nil)
                @date = date
                @professional = professional
                @details = {surname: surname,name: name, phone: phone}
                @details["notes"] = notes unless notes.nil?
            end

            def self.exist?(date, professional)
                #retorna true o false si existe un turno con las caracteristicas recibidas por parametro
                File.exist?("#{Polycon::Utils.path}/#{professional}/#{date}.paf")
            end

            def self.get_appointment(date, professional)
                #obtiene una instancia appointment a partir de un archivo existente
                array = []
                File.open("#{Polycon::Utils.path}/#{professional}/#{date}.paf","r") do |file|
                    file.each { |line| array << line }
                end
                new(date, professional,*array)
            end

            def my_path
                #devuelve la ruta donde se encuentra ubicado el turno, por ejemplo /home/.polycon/Alma Estevez
                "#{Polycon::Utils.path}/#{professional}"
            end

            def create_file
                #crea un archivo .paf con los datos del turno y devuelve un mensaje de operacion exitosa o un mensaje de error en caso que no se pueda
                File.open("#{my_path}/#{@date}.paf", "w") do |file| 
                    details.values.each { |value| file.puts "#{value}"}
                end
                rescue
                    "Ocurrió un error al generar el turno el dia #{@date} para el profesional #{@professional}, por favor intentelo de nuevo"
                else
                    "Se ha creado el turno para el dia #{@date} para el profesional #{@professional}"
            end

            def show
                #imprime en pantalla los datos de un turno formateados de forma nombre : valor
                details.each {|key,value| puts "#{key} : #{value}"}
            end

            def rename(new_date)
                #cambia el nombre del archivo por la fecha recibida por parametro y retorna un mensaje de exito si se pudo renombrar o un mensaje de error en caso contrario
                File.rename("#{my_path}/#{@date}.paf","#{self.my_path}/#{new_date}.paf")
                rescue
                    "No se ha podido reagendar el turno del dia #{@date} al dia #{new_date}"
                else
                    "Se ha reagendado el turno del profesional #{@professional} del dia #{@date} al dia #{new_date}"
            end

            def edit_file(**fields)
                #edita los campos del archivo que se reciban por parametro
            end

            def cancel
                #elimina el turno y devuelve un mensaje de exito si fue eliminado o un mensaje de error en caso contrario
                File.delete("#{my_path}/#{@date}.paf")
                rescue
                    "No se ha podido cancelar el turno del profesional #{@professional} del dia #{@date}"
                else
                    "Se ha cancelado el turno del dia #{@date} del profesional #{@professional}"
            end
        end
    end
end
