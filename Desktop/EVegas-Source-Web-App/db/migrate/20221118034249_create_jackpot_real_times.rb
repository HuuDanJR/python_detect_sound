class CreateJackpotRealTimes < ActiveRecord::Migration[6.0]
  def change
    create_table :jackpot_real_times do |t|
      t.string :data, limit: 2000, default: ""

      t.timestamps
    end
  end
end
