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
          
          profesional = Models::Professionals.new(name)
          begin
            profesional.create_professional_folder #se crea una carpeta en base al profesional creado
          rescue RuntimeError => e #captura los errores que puedan surgir al crear la carpeta
            warn e.message #Imprime el mensaje de error de la excepcion
          else
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
          begin
            professional = Models::Professionals.get_professional(name)
            professional.delete
          rescue SystemCallError #Error que devuelve Dir al querer borrar una carpeta no vacia
            warn "ERROR: El profesional #{name} posee turnos, por lo que no se puede borrar"
          rescue RuntimeError => e
            warn e.message
          else
            puts "Se ha eliminado el profesional #{name}"
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
          professionals = Models::Professionals.list_professionals #obtengo los profesionales
          if professionals.empty?
            puts "No hay profesionales cargados en el sistema"
          else
            puts professionals
          end
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
          begin
            professional = Models::Professionals.get_professional(old_name)
            professional.edit(new_name)
          rescue RuntimeError => e
            warn e.message
          else
            puts "Se ha editado el nombre del profesional #{old_name} por #{new_name}"
          end
          warn "TODO: Implementar renombrado de profesionales con nombre '#{old_name}' para que pase a llamarse '#{new_name}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
        end
      end
    end
  end
end
