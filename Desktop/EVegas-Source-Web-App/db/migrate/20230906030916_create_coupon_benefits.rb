class CreateCouponBenefits < ActiveRecord::Migration[6.0]
  def change
    create_table :coupon_benefits do |t|
      t.references :coupon, null: false, index: true
      t.references :benefit, null: false, index: true
      t.timestamps
    end
  end
end
