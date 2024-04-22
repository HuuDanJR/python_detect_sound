class AddNameToMessage < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :name, :string, limit: 2000, default: ""
  end
end
