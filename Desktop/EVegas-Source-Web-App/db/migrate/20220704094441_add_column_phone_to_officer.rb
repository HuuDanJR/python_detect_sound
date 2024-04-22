class AddColumnPhoneToOfficer < ActiveRecord::Migration[6.0]
  def change
    add_column :officers, :phone, :string, limit: 20, default: ""
  end
end
