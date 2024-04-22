class UpdateTypeJpValueToJackpotMachine < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      change_table :jackpot_machines do |t|
        dir.up { t.change :jp_value, :float }
        dir.down { t.change :jp_value, :decimal }
      end
    end
  end
end
