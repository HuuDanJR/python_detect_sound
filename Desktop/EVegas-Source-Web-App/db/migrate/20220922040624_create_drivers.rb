class CreateDrivers < ActiveRecord::Migration[6.0]
  def change
    create_table :drivers do |t|
      t.string :name
      t.string :nickname
      t.string :position
      t.datetime :date_of_birth
      t.string :phone
      t.boolean :gender, default: 1
      t.timestamps
    end
  end
end
