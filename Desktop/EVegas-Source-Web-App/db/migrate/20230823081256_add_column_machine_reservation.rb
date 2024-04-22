class AddColumnMachineReservation < ActiveRecord::Migration[6.0]
  def change
    add_column :machine_reservations, :zone, :string, default: ""
    add_column :machine_reservations, :results_play, :string, limit: 255
    add_column :machine_reservations, :approved_by, :string, limit: 255
    add_column :machine_reservations, :updated_by, :string, limit: 255
  end
end
