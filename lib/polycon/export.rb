module Polycon
    module Export

        require 'prawn' #gema necesaria para la creacion del documento

        #Arreglo con los bloques de tiempo de los turnos
        SCHEDULE= ["9-00","9-30","10-00","10-30","11-00","11-30","12-00","12-30","13-00","13-30","14-00","14-30","15-00","15-30","16-00","16-30","17-00","17-30","18-00","18-30","19:00","19:30"]

        def self.generarNombrePDF(date,professional)
            professional = "all" if professional.nil?
            if date.length > 1
                "#{Utils.report_path}/schedule-semanal-_#{date.first}-#{professional}.pdf"
            else
                "#{Utils.report_path}/schedule_#{date.first}-#{professional}.pdf"
            end
        end

        def self.export_pdf(professional,appointments,*date)
            #recibe un arreglo de fechas y un hash con un arreglo de turnos de cada dia (turnos[dia] = turnos del dia)
            #Con estos datos se genera un documento pdf con una grilla la cual presenta una columna por dia y una fila por bloque de tiempo, con los turnos en cada bloque correspondiente
            Prawn::Document.generate(self.generarNombrePDF(date,professional)) do |pdf|
                data = [["Hora/Dia", *date]] #header, tiene los o el dia a mostrar
                SCHEDULE.each do |hour| #por cada bloque de tiempo
                    data+= [
                        appointments.keys.inject(["#{hour}"]) do |row,key| #genero una celda por cada dia
                            if appointments[key].select { |appointment| appointment.date == "#{key}_#{hour}" }.empty? #Si no hay turnos para ese dia y hora
                                row.push("")
                            else #Caso contrario tengo una subtabla con la info de cada uno
                                row.push(pdf.make_table((appointments[key].select { |appointment| appointment.date == "#{key}_#{hour}" })
                                .map{ |appointment| [appointment.schedule_format]}, :cell_style => {:size => 9 , :width => 70}))
                            end
                        end
                        ]
                end
                pdf.table(data, :header => true ,:row_colors => ["F0F0F0", "FFFFCC"], :cell_style => { :size => 9})
            end
        end
    end
end