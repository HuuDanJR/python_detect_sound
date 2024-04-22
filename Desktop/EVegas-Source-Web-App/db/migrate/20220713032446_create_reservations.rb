class CreateReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :reservations do |t|
      t.references :customer, null: false, index: true
      t.string :address, limit: 1000, default: ""
      t.datetime :pickup_at
      t.string :customer_note, limit: 255, default: ""
      t.integer :booking_type, default: 1
      t.integer :reservation_type, default: 1
      t.string :driver_name, limit: 255, default: ""
      t.string :driver_mobile, limit: 20, default: ""
      t.string :car_type, limit: 255, default: ""
      t.string :license_plate, limit: 15, default: ""
      t.datetime :arrival_at
      t.string :internal_note, limit: 255, default: ""
      t.integer :price
      t.decimal :distance
      t.datetime :drop_off_at
      t.integer :status, default: 1
      t.timestamps
    end
  end
end
