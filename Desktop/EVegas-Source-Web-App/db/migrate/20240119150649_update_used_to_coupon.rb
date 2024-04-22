class UpdateUsedToCoupon < ActiveRecord::Migration[6.0]
  def change
    add_column :coupons, :used, :integer, default: 0
  end
end
