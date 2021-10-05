module Polycon
    module Models
        class Professionals
            def initialize(name)
                #Se reemplazan los espacios del nombre por un _
                @name = name.gsub(" ", "_")
            end

            def self.professional_exists?(name)
                #To do: Devolver true o false dependiendo de que exista una carpeta con ese nombre, ya que implica que ya existe
            end

            def self.get_professional(name)
                #Devuelve un profesional en base a la carpeta que coincida con el nombre pasado por parametro
            end
            
            def self.list_professionals()
                #Devuelve un listado con todos los profesionales creados en el sistema
            end

            def has_appointments?()
                #TODO: Devolver true o false si el profesional tiene turnos, para limitar su borrado
            end

            def delete_profesional()
                #Elimina la carpeta del profesional, no debe tener turnos
            end

            def edit_professional(name)
                #Modifica el nombre de la carpeta del profesional por el nuevo nombre
            end

            def to_s()
                #Devuelve el profesional como nombre
                @name
            end

            def create_professional_folder()
                #crea una carpeta con el professional existente
            end
            
        end
    end
end

