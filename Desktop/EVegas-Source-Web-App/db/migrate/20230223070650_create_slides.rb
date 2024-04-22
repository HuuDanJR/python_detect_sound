class CreateSlides < ActiveRecord::Migration[6.0]
  def change
    create_table :slides do |t|
      t.string :name, limit: 255, default: ""
      t.integer :index, default: 0
      t.references :attachment, index: true

      t.timestamps
    end
  end
end
