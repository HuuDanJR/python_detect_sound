class AddColumnCurrentLocationToReservations < ActiveRecord::Migration[6.0]
  def change
    add_column :reservations, :current_location, :string, limit: 1000, default: ""
  end
end
