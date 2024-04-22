class AddTimeStartToCoupon < ActiveRecord::Migration[6.0]
  def change
    add_column :coupons, :time_start, :datetime, default: DateTime.now
  end
end
