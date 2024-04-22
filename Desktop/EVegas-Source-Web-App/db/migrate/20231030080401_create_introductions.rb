class CreateIntroductions < ActiveRecord::Migration[6.0]
  def change
    create_table :introductions do |t|
      t.string :title
      t.string :description
      t.integer :intro_index
      t.references :attachment, index: true

      t.timestamps
    end
  end
end
