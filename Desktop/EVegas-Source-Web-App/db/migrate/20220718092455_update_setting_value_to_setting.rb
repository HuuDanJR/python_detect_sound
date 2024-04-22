class UpdateSettingValueToSetting < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      change_table :settings do |t|
      dir.up { t.change :setting_value, :string, limit: 1000 }
      dir.down { t.change :setting_value, :string, limit: 255 }
      end
    end
  end
end
