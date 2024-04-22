class UpdateUniqueDeviceIdToDevice < ActiveRecord::Migration[6.0]
  def change
    add_index :devices, :token, unique: true
  end
end
