class UpdateJpValueToJackpotMachine < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      change_table :jackpot_machines do |t|
        dir.up { t.change :jp_value, :decimal, default: 0 }
        dir.down { t.change :jp_value, :integer }
      end
    end
  end
end
