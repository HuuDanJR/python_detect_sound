class CreateAccommodations < ActiveRecord::Migration[6.0]
  def change
    create_table :accommodations do |t|
      t.string :name
      t.string :note
      t.date :date_pick
      t.time :time_pick

      t.timestamps
    end
  end
end
