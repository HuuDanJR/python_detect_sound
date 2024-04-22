class CreateCouponBenefitTimes < ActiveRecord::Migration[6.0]
  def change
    create_table :coupon_benefit_times do |t|
      t.bigint :coupon_id
      t.bigint :benefit_id
      t.datetime :time_used
    end
  end
end
