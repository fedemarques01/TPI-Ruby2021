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
          Utils.check_polycon_exists
          
          #validaciones del parametro recibido
          if not Utils.valid_string?(name) #reviso que el nombre sea valido
            warn "ERROR: El nombre de profesional #{name} no es valido"
          elsif Models::Professionals.exist?(name) #reviso que no exista el profesional
            warn "ERROR: El profesional #{name} ya existe en el sistema"
          else #todo correcto
            profesional = Models::Professionals.new(name)
            profesional.create_professional_folder #se crea una carpeta en base al profesional creado
            puts "Se ha creado el profesional con el nombre #{name}" 
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
          Utils.check_polycon_exists

          if not Models::Professionals.exist?(name) #reviso que si existe el profesional
            warn "ERROR: El profesional #{name} no existe en el sistema"
          else #todo correcto
            profesional = Models::Professionals.new(name)
            puts profesional.delete #se crea una carpeta en base al profesional creado
          end
          
        end
      end

      class List < Dry::CLI::Command
        desc 'List professionals'

        example [
          "          # Lists every professional's name"
        ]

        def call(*)
          Utils.check_polycon_exists
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
          Utils.check_polycon_exists
          
          if not Models::Professionals.exist?(old_name) #reviso si no existe el profesional
            warn "ERROR: El profesional #{old_name} no existe en el sistema"
          elsif not Utils.valid_string?(new_name) #reviso que el nombre sea valido
            warn "ERROR: El nuevo nombre #{new_name} no es valido para un profesional"
          elsif Models::Professionals.exist?(new_name) #reviso que no exista un profesional con el nombre nuevo
            warn "ERROR: El profesional #{new_name} ya existe en el sistema"
          else
            profesional = Models::Professionals.new(old_name)
            profesional.rename(new_name)
            puts "Se ha editado el nombre del profesional #{old_name} por #{new_name}"
          end
          #warn "TODO: Implementar renombrado de profesionales con nombre '#{old_name}' para que pase a llamarse '#{new_name}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end
    end
  end
end
