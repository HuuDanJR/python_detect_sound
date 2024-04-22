class CreatePyramidPoints < ActiveRecord::Migration[6.0]
  def change
    create_table :pyramid_points do |t|
      t.string :prize, limit: 255
      t.integer :min_point
      t.integer :max_point
      t.timestamps
    end
  end
end
