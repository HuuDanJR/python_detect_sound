class AddNoteToCouponBenefits < ActiveRecord::Migration[6.0]
  def change
    add_column :coupon_benefits, :note, :string, limit: 2000, default: ""
  end
end
