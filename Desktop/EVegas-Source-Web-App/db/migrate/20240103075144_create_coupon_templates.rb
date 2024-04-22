class CreateCouponTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :coupon_templates do |t|
      t.string :name
      t.text :description
      t.string :benefit_ids

      t.timestamps
    end
  end
end
