class CreatePromotions < ActiveRecord::Migration[6.0]
  def change
    create_table :promotions do |t|
      t.string :name
      t.string :terms, limit: 4000
      t.string :prize, limit: 4000
      t.string :issue_date
      t.string :game_type
      t.string :day_of_week
      t.string :day_of_month
      t.string :day_of_season
      t.string :time
      t.string :remark
      t.integer :status
      t.references :attachment, null: false, index: true
      t.references :promotion_category, null: false, index: true
      t.timestamps
    end
  end
end
