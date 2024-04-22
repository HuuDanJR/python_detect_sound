class AddNoteToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :internal_note, :string
  end
end
