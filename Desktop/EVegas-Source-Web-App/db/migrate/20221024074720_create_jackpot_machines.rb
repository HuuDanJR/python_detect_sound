class CreateJackpotMachines < ActiveRecord::Migration[6.0]
  def change
    create_table :jackpot_machines do |t|
      t.integer :mc_number
      t.string :mc_name
      t.datetime :jp_date
      t.integer :jp_value

      t.references :jackpot_game_type, index: true, null: true
      t.timestamps
    end
  end
end
