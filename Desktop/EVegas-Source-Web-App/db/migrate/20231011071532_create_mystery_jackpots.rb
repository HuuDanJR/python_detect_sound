class CreateMysteryJackpots < ActiveRecord::Migration[6.0]
  def change
    create_table :mystery_jackpots do |t|
      t.datetime :jp_date, default: Time.zone.now
      t.string :jp_game_theme
      t.string :mc_number
      t.string :mc_name
      t.decimal :jp_value, :precision => 15, :scale => 2
      t.integer :jp_occurrence_id, default: 0
      t.boolean :is_send, default: 0
      t.boolean :has_send, default: 0
      t.timestamps
    end
  end
end
