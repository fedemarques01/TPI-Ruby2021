module Polycon
    module Models
        class Professionals

            attr_reader :name
            def initialize(name)
                @name = name
            end

            def self.get_professional(name)
                #Devuelve un objeto profesional en base al nombre recibido por parametro si existe una carpeta con ese nombre
                #caso contrario retorna nil
                if Dir.exist?(Polycon::Utils.path << "/#{name}")
                    new(name) 
                end
            end
            
            def self.list_professionals
                #Devuelve un arreglo con el nombre de todos los profesionales creados en el sistema, será un arreglo vacio si no hay ninguno creado
                Dir.children(Polycon::Utils.path)
            end

            def has_appointments?
                #Devuelve true o false si el directorio del profesional esta vacio
                Dir.empty?(Polycon::Utils.path << "/#{@name}")
            end

            def delete_profesional
                #Elimina la carpeta del profesional, no debe tener turnos
                if Dir.empty?(Polycon::Utils.path << "/#{@name}")
                    Dir.delete(Polycon::Utils.path << "/#{@name}")
                end
            end

            def edit_professional(name)
                #Modifica el nombre de la carpeta del profesional por el nuevo nombre
            end

            def create_professional_folder
                #crea una carpeta con el nombre del profesional
                #Si ya existe, levanta una excepcion con el mensaje de que ya existe un profesional con ese nombre
                #Si el nombre contiene /, levanta una excepcion indicando que el nombre no debe llevar tal caracter ya que los archivos no pueden llevar ese caracter en el nombre
                #Si es un string vacio o tiene solo espacios, levanta una excepcion indicando que no puede estar vacio o contener solo espacios
                if @name.gsub(" ","").empty?
                    raise StandardError.new("El nombre del profesional no puede estar vacio o poseer solo espacios")
                elsif @name.include?("/")
                    raise StandardError.new("El nombre del profesional no puede llevar /")
                elsif Dir.exist?(Polycon::Utils.path << "/#{@name}")
                    raise StandardError.new("El profesional #{@name} ya existe")
                end
                Dir.mkdir(Polycon::Utils.path << "/#{@name}")
            end
        end
    end
end

