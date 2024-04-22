class CreateTermServices < ActiveRecord::Migration[6.0]
  def change
    create_table :term_services do |t|
      t.string :name
      t.text :content
      t.integer :index

      t.timestamps
    end
  end
end
