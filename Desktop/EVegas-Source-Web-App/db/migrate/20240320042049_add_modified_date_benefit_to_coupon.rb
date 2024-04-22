class AddModifiedDateBenefitToCoupon < ActiveRecord::Migration[6.0]
  def change
    add_column :coupons, :modified_date, :datetime, default: ""
  end
end
