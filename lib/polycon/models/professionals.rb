module Polycon
    module Models
        class Professionals

            attr_accessor :name
            def initialize(name)
                @name = name
            end
            
            def self.exist?(name)
                #Devuelve true o false dependiendo de que exista una carpeta con ese profesional en el sistema
                Dir.exist?(Polycon::Utils.path << "/#{name}")
            end

            def create_professional_folder
                #crea una carpeta con el nombre del profesional
                Dir.mkdir(Polycon::Utils.path << "/#{@name}")
            end

            def delete
                #Elimina la carpeta del profesional, si tiene turnos rescata la excepcion y devuelve un mensaje explicando el porque no se borro, caso contrario retorna un mensaje de confirmacion de operacion
                Dir.delete(Polycon::Utils.path << "/#{@name}")
                rescue SystemCallError
                    "El profesional #{@name} posee turnos, por lo que no puede borrarse"
                else
                    "El profesional #{@name} ha sido borrado del sistema"
            end

            def self.list_professionals
                #Devuelve un arreglo con el nombre de todos los profesionales creados en el sistema, será un mensaje de que no hay profesionales si no hay ninguno creado
                if Dir.children(Polycon::Utils.path).empty?
                    "No hay profesionales cargados en el sistema"
                else
                    Dir.children(Polycon::Utils.path)
                end
            end

            def rename(newName)
                #Modifica el nombre de la carpeta del profesional por el nuevo nombre
                File.rename(Polycon::Utils.path << "/#{@name}", Polycon::Utils.path << "/#{newName}")
            end

        end
    end
end

