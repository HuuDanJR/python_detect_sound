class AddSerialNoToCoupon < ActiveRecord::Migration[6.0]
  def change
    add_column :coupons, :serial_no, :string, limit: 255
  end
end
