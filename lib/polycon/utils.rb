module Polycon
    module Utils
        def self.check_polycon_exists
            if not Dir.exist?(Dir.home << "/.polycon")
                warn "ADVERTENCIA: No se ha podido encontrar la carpeta .polycon.\nSe ha creado la carpeta .polycon en su directorio home para almacenar la informacion sobre profesionales y turnos"
                Dir.mkdir(Dir.home << "/.polycon")
            end
        end

        def self.path
            Dir.home << "/.polycon"
        end

        def self.valid_string?(name)
            #Valida que el string sea valido para referenciar un nombre de archivo en un sistema Unix
            if self.blank_string?(name) or name.include?("/")
                false
            else
                true
            end
        end

        def self.blank_string?(name)
            #devuelve true o false si el string posee solo espacios o está vacio
            name.strip.empty?
        end
    end
end