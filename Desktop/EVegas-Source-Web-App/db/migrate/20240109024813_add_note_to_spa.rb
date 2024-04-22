class AddNoteToSpa < ActiveRecord::Migration[6.0]
  def change
    add_column :spas, :note_confirm, :string, limit: 2000, default: ""
    add_column :spas, :note_cancel, :string, limit: 2000, default: ""
  end
end
