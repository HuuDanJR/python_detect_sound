class ChangColumnSettingValueToSetting < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      change_table :settings do |t|
      dir.up { t.change :setting_value, :string, limit: 4000 }
      dir.down { t.change :setting_value, :string, limit: 1000 }
      end
    end
  end
end
