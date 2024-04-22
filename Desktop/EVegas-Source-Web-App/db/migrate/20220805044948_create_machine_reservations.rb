class CreateMachineReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :machine_reservations do |t|
      t.references :customer, null: false, index: true
      t.integer :machine_number
      t.string :machine_name, limit: 255, default: ""
      t.datetime :started_at
      t.datetime :ended_at
      t.string :customer_note, limit: 255, default: ""
      t.integer :booking_type, default: 1
      t.string :internal_note, limit: 255, default: ""
      t.integer :status, default: 1
      t.timestamps
    end
  end
end
