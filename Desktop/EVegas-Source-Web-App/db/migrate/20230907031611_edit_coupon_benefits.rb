class EditCouponBenefits < ActiveRecord::Migration[6.0]
  def change
    change_table :coupon_benefits do |t|
      t.integer :count_usage
      t.integer :total_usage
    end
  end
end