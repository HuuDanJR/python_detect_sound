class AddNoteToMachineReservation < ActiveRecord::Migration[6.0]
  def change
    add_column :machine_reservations, :note_confirm, :string, limit: 2000, default: ""
    add_column :machine_reservations, :note_cancel, :string, limit: 2000, default: ""
    add_column :machine_reservations, :note_finish, :string, limit: 2000, default: ""
  end
end
