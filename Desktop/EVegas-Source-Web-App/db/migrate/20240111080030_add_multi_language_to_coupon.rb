class AddMultiLanguageToCoupon < ActiveRecord::Migration[6.0]
  def change
    add_column :coupons, :description_ja, :text
    add_column :coupons, :description_kr, :text
    add_column :coupons, :description_cn, :text
  end
end
