class AddDeviceIdToDevice < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :device_id, :string, limit: 128, default: ""
  end
end
