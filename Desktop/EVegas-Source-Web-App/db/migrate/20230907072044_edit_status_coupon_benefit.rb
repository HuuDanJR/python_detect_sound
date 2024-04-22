class EditStatusCouponBenefit < ActiveRecord::Migration[6.0]
  def change
    change_table :coupon_benefits do |t|
      t.integer :status
    end
    change_table :coupons do |t|
      t.integer :status
    end
  end
end
