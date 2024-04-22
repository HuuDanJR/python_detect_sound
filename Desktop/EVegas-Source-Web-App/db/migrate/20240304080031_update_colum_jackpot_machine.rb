class UpdateColumJackpotMachine < ActiveRecord::Migration[6.0]
  def change
    change_column :jackpot_machines, :jp_value, :float
  end
end
