module Polycon
    module Models
        class Professionals

            def initialize(name)
                @name = name
            end

            def self.get_professional(name)
                #Devuelve un objeto profesional en base al nombre recibido por parametro 
                #si existe una carpeta con ese nombre
                #caso contrario retorna nil
                if Dir.exist?(Polycon::Utils.path << "/#{name}")
                    new(name) 
                end
            end
            
            def self.list_professionals
                #Devuelve un listado con todos los profesionales creados en el sistema
                Dir.each_child(Polycon::Utils.path) { |x| puts x.gsub("_"," ")}
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

            def to_s
                #Devuelve el profesional como nombre
                @name
            end

            def create_professional_folder
                #crea una carpeta nombre del profesional, si ya existe levanta una excepcion de tipo AlreadyExistError
                if Dir.exist?(Polycon::Utils.path << "/#{@name}")
                    raise StandardError.new("El profesional #{@name} ya existe")
                end
                Dir.mkdir(Polycon::Utils.path << "/#{@name}")
            end
        end
    end
end

