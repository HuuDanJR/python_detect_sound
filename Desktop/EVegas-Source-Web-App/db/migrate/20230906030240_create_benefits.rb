class CreateBenefits < ActiveRecord::Migration[6.0]
  def change
    create_table :benefits do |t|
      t.string :name, limit: 255, default: ""
      t.integer :times, default: 1
      t.references :attachment, index: true

      t.timestamps
    end
  end
end
