class UpdateColumnJackpotMachine < ActiveRecord::Migration[6.0]
  def change
    change_column :jackpot_machines, :jp_value, :decimal, :precision => 10, :scale => 2
  end
end
