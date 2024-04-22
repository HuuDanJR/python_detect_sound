class AddColumnReceptionToOfficer < ActiveRecord::Migration[6.0]
  def change
    add_column :officers, :is_reception, :boolean, default: 0
  end
end
