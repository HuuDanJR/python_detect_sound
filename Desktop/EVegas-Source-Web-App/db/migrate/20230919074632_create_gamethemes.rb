class CreateGamethemes < ActiveRecord::Migration[6.0]
  def change
    create_table :gamethemes do |t|
      t.integer :game_type_id
      t.string :name
      t.references :attachment, index: true

      t.timestamps
    end
  end
end
