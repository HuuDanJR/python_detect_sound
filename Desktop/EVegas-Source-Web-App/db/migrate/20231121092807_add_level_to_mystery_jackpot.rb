class AddLevelToMysteryJackpot < ActiveRecord::Migration[6.0]
  def change
    add_column :jackpot_machines, :mystery_jackpot_level, :integer, default: 0
  end
end
