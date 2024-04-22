class AddNoteToAccommodation < ActiveRecord::Migration[6.0]
  def change
    add_column :accommodations, :note_confirm, :string, limit: 2000, default: ""
    add_column :accommodations, :note_cancel, :string, limit: 2000, default: ""
  end
end
