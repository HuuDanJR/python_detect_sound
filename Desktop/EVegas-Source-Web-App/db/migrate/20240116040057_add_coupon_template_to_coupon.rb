class AddCouponTemplateToCoupon < ActiveRecord::Migration[6.0]
  def change
    add_column :coupons, :coupon_template_id, :bigint
    add_index  :coupons, :coupon_template_id
  end
end
