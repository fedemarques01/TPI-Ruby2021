class CreateAppointments < ActiveRecord::Migration[6.1]
  def change
    create_table :appointments do |t|
      t.datetime :date, null:false
      t.string :patient_name, null:false
      t.string :patient_surname, null:false
      t.string :phone, null:false
      t.text :notes, null:true
      t.belongs_to :professional, null: false, foreign_key: true

      t.timestamps
    end
  end
end
