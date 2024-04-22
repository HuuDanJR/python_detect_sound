class AddTotalUsageToCouponTemplate < ActiveRecord::Migration[6.0]
  def change
    add_column :coupon_templates, :benefit_totals, :string, limit: 255, default: ""
  end
end
