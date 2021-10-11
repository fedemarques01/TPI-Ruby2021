module Polycon
    module Utils
        def self.ensure_polycon_exists
            if not Dir.exist?(self.path)
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
        
        require 'date' #modulo necesario para la validacion de fechas
        def self.valid_date?(date)
            #devuelve true o false si la fecha recibida por parametro es una fecha valida con formato AAAA-MM-DD HH:II
            DateTime.strptime(date,"%Y-%m-%d_%H-%M")
            rescue
                false
            else
                true
        end

        #Este metodo recibe un hash variable de opciones obligatorias y revisa que las opciones ingresadas no sean strings vacios o solo de espacios
        #Retorna un mensaje donde especifica los parametros que son strings vacios o de solo espacios
        #En el caso donde ninguno este vacio, retorna un string vacio
        def self.check_options(**options)
            message = ""
            options.each { 
                |key,value| if self.blank_string?(value)
                message << "El parametro #{key} no puede ser una cadena vacia\n" 
            end
            }
            message
        end
    end
end