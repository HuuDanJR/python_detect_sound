class CreatePromotionReactions < ActiveRecord::Migration[6.0]
  def change
    create_table :promotion_reactions do |t|
      t.integer :reaction_type
      t.references :user, index: true
      t.references :promotion, index: true

      t.timestamps
    end
  end
end
