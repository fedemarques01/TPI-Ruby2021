module Polycon
    module Export

        require 'prawn' #gema necesaria para la creacion del documento

        #Arreglo con los bloques de tiempo de los turnos
        SCHEDULE= ["9-00","9-30","10-00","10-30","11-00","11-30","12-00","12-30","13-00","13-30","14-00","14-30","15-00","15-30","16-00","16-30","17-00","17-30","18-00","18-30","19-00","19-30"]

        def self.generar_pdf_name(date,professional)
            professional ||= "all"
            if date.length > 1 then
                "#{Utils.report_path}/schedule-semanal-_#{date.first}-#{professional}.pdf"
            else
                "#{Utils.report_path}/schedule_#{date.first}-#{professional}.pdf"
            end
        end

        def self.make_subtable(pdf,appointments,key,hour)
            #metodo que genera una subtabla con la informacion de cada turno en ese dia y bloque horario
            pdf.make_table((appointments[key].select { |appointment| appointment.date == "#{key}_#{hour}" })
                    .map{ |appointment| [appointment.schedule_format]}, :cell_style => {:size => 9 , :width => 70})
        end

        def self.make_row(pdf,appointments,hour)
            #Metodo que genera una fila con la informacion de los turnos de los dias a procesar en un bloque horario
            appointments.keys.inject(["#{hour}"]) do |row,key| #genero una celda por cada dia a procesar
                if appointments[key].select { |appointment| appointment.date == "#{key}_#{hour}" }.empty? #Si no hay turnos para ese dia y hora hago una celda vacia
                    row.push("")
                else #Caso contrario genero una subtabla con la info de cada turno a procesar
                    row.push(self.make_subtable(pdf,appointments,key,hour)) #genero una subtabla con la informacion de cada turno de ese horario
                end
            end
        end

        def self.generate_table(pdf, appointments)
            #metodo que genera un arreglo con el resto de filas de la tabla con la informacion de los turnos de cada bloque horario de los dias a procesar
            SCHEDULE.inject([]) do |data, hour| #por cada bloque de tiempo
                data+= [
                    self.make_row(pdf,appointments,hour) #llamo al metodo para generar filas
                    ]
            end
        end

        def self.export_pdf(professional,appointments,*date)
            #recibe un arreglo de fechas y un hash con un arreglo de turnos de cada dia (turnos[dia] = turnos del dia)
            #Con estos datos se genera un documento pdf con una grilla la cual presenta una columna por dia y una fila por bloque de tiempo, con los turnos en cada bloque correspondiente
            Prawn::Document.generate(self.generate_pdf_name(date,professional)) do |pdf|
                data = [["Hora/Dia", *date]] #header, tiene los o el dia a mostrar
                data += self.generate_table(pdf,appointments) #cargo la informacion del resto de filas de la tabla
                pdf.table(data, :header => true ,:row_colors => ["F0F0F0", "FFFFCC"], :cell_style => { :size => 9})
            end
        end
    end
end