class UpdateDevices < ActiveRecord::Migration[6.0]
  def change
    add_column :devices, :time_expired, :datetime, limit: 6
  end
end
