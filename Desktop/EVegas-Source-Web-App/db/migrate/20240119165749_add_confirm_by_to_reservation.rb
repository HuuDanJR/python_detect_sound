class AddConfirmByToReservation < ActiveRecord::Migration[6.0]
  def change
    add_column :reservations, :confirm_by, :string, limit: 255, default: ""
  end
end
