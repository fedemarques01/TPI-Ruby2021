# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
consulta = Role.create({name: "consulta"})
asistencia = Role.create({name: "asistencia"})
admin = Role.create({name: "administracion"})

User.create({username: "consultor", password: "consultor123", role: consulta})
User.create({username: "asistente", password: "asistente123", role: asistencia})
User.create({username: "admin", password: "admin123", role: admin})

professionals = Professional.create([{name: "Alma", surname: "Estevez"},
    {name: "Luis", surname: "Miguel"},
    {name: "Javier", surname: "Ramirez"}
])

rand(5..10).times do |i|
    professional = professionals.sample #agarro un professional
    date = rand(5..10).days.ago.at_beginning_of_day + rand(9..19).hours #genera una fecha al azar
    Appointment.create({
        professional: professional, 
        date: date,
        patient_name: "Paciente" ,
        patient_surname: "de #{professional.name}", 
        phone: "#{rand(1..10)}"
    }) #turno generico
end