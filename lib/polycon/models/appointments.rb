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
                    file.each { |line| array << line }
                end
                new(date, professional,*array)
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
