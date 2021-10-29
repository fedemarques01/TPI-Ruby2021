module Polycon
    module Utils

        require 'date' #modulo necesario para la validacion de fechas

        
        def self.ensure_polycon_exists
            if ! Dir.exist?(self.path)
                warn "ADVERTENCIA: No se ha podido encontrar la carpeta .polycon.\nSe ha creado la carpeta .polycon en su directorio home para almacenar la informacion sobre profesionales y turnos"
                Dir.mkdir(Dir.home << "/.polycon")
            end
        end

        def self.path
            Dir.home << "/.polycon"
        end

        def self.valid_string?(name)
            #Valida que el string sea valido para referenciar un nombre de archivo en un sistema Unix
            if self.blank_string?(name) || name.include?("/")
                false
            else
                true
            end
        end

        def self.blank_string?(name)
            #devuelve true o false si el string posee solo espacios o está vacio
            name.strip.empty?
        end
        
        
        def self.valid_date_with_hour?(date)
            #devuelve true o false si la fecha recibida por parametro es una fecha valida con formato AAAA-MM-DD_HH-II
            DateTime.strptime(date,"%Y-%m-%d_%H-%M")
            rescue
                false
            else
                true
        end

        def self.report_path
            #Devuelve la ruta hacia la carpeta donde se guardan las grillas generadas y si no existe la crea
            Dir.mkdir(Dir.home << "/.polycon-schedules") unless Dir.exist?(Dir.home << "/.polycon-schedules") 
            Dir.home << "/.polycon-schedules"
        end

        def self.valid_date?(date)
            #devuelve true o false si es una fecha valida en formato AAAA-MM-DD
            DateTime.strptime(date,"%Y-%m-%d")
            rescue
                false
            else
                true
        end

        def self.get_week_as_string(date)
            #devuelve un arreglo con los 7 dias de la semana de la fecha recibida por paremtro, cada elemento esta en formato string
            date_object = Date.strptime(date,"%Y-%m-%d")
            date_object = date_object - (date_object.wday - 1)%7 #obtengo el primer dia de la semana
            (date_object..date_object+6).map{ |date| date.to_s.strip}
        end

        #Este metodo recibe un hash variable de opciones obligatorias y revisa que las opciones ingresadas no sean strings vacios o solo de espacios
        #Retorna un hash con los parametros que son strings vacios
        #En el caso donde ninguno este vacio, retorna un hash vacio
        def self.check_options(**options)
            options.select { |key,value| self.blank_string?(value) }
        end

    end
end