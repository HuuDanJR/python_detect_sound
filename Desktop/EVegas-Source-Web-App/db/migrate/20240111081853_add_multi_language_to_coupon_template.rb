class AddMultiLanguageToCouponTemplate < ActiveRecord::Migration[6.0]
  def change
    add_column :coupon_templates, :description_ja, :text
    add_column :coupon_templates, :description_kr, :text
    add_column :coupon_templates, :description_cn, :text
  end
end
