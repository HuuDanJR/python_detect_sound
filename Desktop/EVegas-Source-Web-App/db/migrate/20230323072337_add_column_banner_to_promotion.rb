class AddColumnBannerToPromotion < ActiveRecord::Migration[6.0]
  def change
    add_column :promotions, :banner_id, :bigint
    add_index  :promotions, :banner_id
  end
end
