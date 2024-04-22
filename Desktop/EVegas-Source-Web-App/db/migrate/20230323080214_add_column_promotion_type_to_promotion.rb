class AddColumnPromotionTypeToPromotion < ActiveRecord::Migration[6.0]
  def change
    add_column :promotions, :promotion_type, :integer, default: 1
  end
end
