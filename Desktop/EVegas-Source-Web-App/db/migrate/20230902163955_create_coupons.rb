class CreateCoupons < ActiveRecord::Migration[6.0]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :title
      t.string :description
      t.string :mb
      t.string :no
      t.string :issued
      t.datetime :expired
      t.references :customer, index: true

      t.timestamps
    end
  end
end
