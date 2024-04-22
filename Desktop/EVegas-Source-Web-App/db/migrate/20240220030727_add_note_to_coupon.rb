class AddNoteToCoupon < ActiveRecord::Migration[6.0]
  def change
    add_column :coupons, :note, :string, limit: 2000, default: ""
  end
end
