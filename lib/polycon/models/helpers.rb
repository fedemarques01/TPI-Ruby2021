module Polycon
    module Models
        module Helpers
            #Metodo que valida que el nombre pasado por parametro sea correcto para crear una carpeta en el sistema
            def self.validate_folder_name(name)
                #Primer caso: String vacio o solo espacios
                #Segundo caso: String con el caracter /
                #Tercer caso: Una carpeta con ese nombre ya existe
                #En los tres casos se levantara una excepcion de tipo RuntimeError( error en ejecucion), sin embargo cada una tendrá un mensaje personalizado con lo que ocasionó el error
                if name.gsub(" ","").empty?
                    raise RuntimeError.new("ERROR: El nombre del profesional no puede estar vacio o poseer solo espacios")
                elsif name.include?("/")
                    raise RuntimeError.new("ERROR: El nombre del profesional no puede llevar /")
                elsif Dir.exist?(Polycon::Utils.path << "/#{name}")
                    raise RuntimeError.new("ERROR: El profesional #{name} ya existe")
                end
            end
        end
    end
end