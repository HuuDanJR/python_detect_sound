class CreatePromotionSubscribers < ActiveRecord::Migration[6.0]
  def change
    create_table :promotion_subscribers do |t|
      t.datetime :time_send
      t.boolean :is_send
      t.references :user, index: true
      t.references :promotion, index: true

      t.timestamps
    end
  end
end
