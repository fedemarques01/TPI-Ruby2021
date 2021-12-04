class CreateProfessionals < ActiveRecord::Migration[6.1]
  def change
    create_table :professionals do |t|
      t.string :name, null: false
      t.string :surname, null: false
      
      t.timestamps
    end
  end
end
