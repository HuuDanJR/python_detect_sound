class AddNameMutiLanguageToCouponTemplate < ActiveRecord::Migration[6.0]
  def change
    add_column :coupon_templates, :name_ja, :string, limit: 1000, default: ""
    add_column :coupon_templates, :name_kr, :string, limit: 1000, default: ""
    add_column :coupon_templates, :name_cn, :string, limit: 1000, default: ""
  end
end
