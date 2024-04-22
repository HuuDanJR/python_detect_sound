class AddNameMutiLanguageToCoupon < ActiveRecord::Migration[6.0]
  def change
    add_column :coupons, :name_ja, :string, limit: 1000, default: ""
    add_column :coupons, :name_kr, :string, limit: 1000, default: ""
    add_column :coupons, :name_cn, :string, limit: 1000, default: ""
  end
end
