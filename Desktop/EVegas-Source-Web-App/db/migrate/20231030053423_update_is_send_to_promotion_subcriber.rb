class UpdateIsSendToPromotionSubcriber < ActiveRecord::Migration[6.0]
  def change
    change_column :promotion_subscribers, :is_send, :boolean, null: false, default: 0
  end
end
