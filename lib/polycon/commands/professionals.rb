module Polycon
  module Commands
    module Professionals
      class Create < Dry::CLI::Command
        desc 'Create a professional'

        argument :name, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez"      # Creates a new professional named "Alma Estevez"',
          '"Ernesto Fernandez" # Creates a new professional named "Ernesto Fernandez"'
        ]

        def call(name:, **)
          Utils.ensure_polycon_exists
          
          #validaciones del parametro recibido
          if ! Utils.valid_string?(name) #reviso que el nombre sea valido
            warn "ERROR: El nombre de profesional #{name} no es valido"
          elsif Models::Professionals.exist?(name) #reviso que no exista el profesional
            warn "ERROR: El profesional #{name} ya existe en el sistema"
          else #todo correcto
            profesional = Models::Professionals.new(name)
            begin
              profesional.create_professional_folder #Crea la carpeta del profesional
            rescue #Mensaje en caso de que haya un error al crear la carpeta
              puts "Ocurrio un error al crear la carpeta del profesional #{name}"
            else #Mensaje de exito
              puts "Se ha creado la carpeta del profesional #{name}"
            end
          end
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a professional (only if they have no appointments)'

        argument :name, required: true, desc: 'Name of the professional'

        example [
          '"Alma Estevez"      # Deletes a new professional named "Alma Estevez" if they have no appointments',
          '"Ernesto Fernandez" # Deletes a new professional named "Ernesto Fernandez" if they have no appointments'
        ]

        def call(name: nil)
          Utils.ensure_polycon_exists

          if Utils.blank_string?(name)
            warn "ERROR: El nombre ingresado esta vacio"
          elsif ! Models::Professionals.exist?(name) #reviso que si existe el profesional
            warn "ERROR: El profesional #{name} no existe en el sistema"
          else #se puede intentar borrar el profesional
            profesional = Models::Professionals.new(name)
            begin
              profesional.delete #Elimina la carpeta del profesional
            rescue SystemCallError #Mensaje en caso de que haya un error al eliminar la carpeta, es decir, que posea turnos
              puts "El profesional #{name} posee turnos, por lo que no puede borrarse"
            else #Mensaje de exito
              puts "El profesional #{name} ha sido borrado del sistema"
            end
          end
          
        end
      end

      class List < Dry::CLI::Command
        desc 'List professionals'

        example [
          "          # Lists every professional's name"
        ]

        def call(*)
          Utils.ensure_polycon_exists
          puts Models::Professionals.list_professionals #obtengo los profesionales y los imprimo en la consola
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a professional'

        argument :old_name, required: true, desc: 'Current name of the professional'
        argument :new_name, required: true, desc: 'New name for the professional'

        example [
          '"Alna Esevez" "Alma Estevez" # Renames the professional "Alna Esevez" to "Alma Estevez"',
        ]

        def call(old_name:, new_name:, **)
          Utils.ensure_polycon_exists
          
          #validaciones antes de renombrar un archivo
          if Utils.blank_string?(old_name) #reviso si el nombre viejo esta en blanco
            warn "ERROR: El nombre de profesional ingresado esta vacio"
          elsif ! Models::Professionals.exist?(old_name) #reviso si no existe el profesional
            warn "ERROR: El profesional #{old_name} no existe en el sistema"
          elsif ! Utils.valid_string?(new_name) #reviso que el nombre sea valido
            warn "ERROR: El nuevo nombre #{new_name} no es valido para un profesional"
          elsif Models::Professionals.exist?(new_name) #reviso que no exista un profesional con el nombre nuevo
            warn "ERROR: El profesional #{new_name} ya existe en el sistema"
          else
            profesional = Models::Professionals.new(old_name)
            begin
              profesional.rename(new_name) #Se imprime el mensaje que devuelve el renombrar un profesional
            rescue
              puts "No pudo renombrarse el profesional #{old_name} a #{new_name}"
            else
              puts "Se renombró el profesional #{old_name} a #{new_name}"
            end
          end
          #warn "TODO: Implementar renombrado de profesionales con nombre '#{old_name}' para que pase a llamarse '#{new_name}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end
    end
  end
end
