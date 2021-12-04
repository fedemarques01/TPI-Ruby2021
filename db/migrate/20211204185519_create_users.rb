class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password, null: false
      t.belongs_to :role, null: false, foreign_key: true

      t.timestamps
    end
    add_index :users, :username, unique: true
  end
end
