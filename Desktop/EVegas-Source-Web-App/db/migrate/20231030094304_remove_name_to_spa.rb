class RemoveNameToSpa < ActiveRecord::Migration[6.0]
  def change
    remove_column :spas, :name
  end
end
