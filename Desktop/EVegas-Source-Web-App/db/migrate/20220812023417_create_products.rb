class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :sku, limit: 10, default: ""
      t.string :qrcode, limit: 255, default: ""
      t.string :name, limit: 255, default: ""
      t.string :desc, limit: 255, default: ""
      t.decimal :base_price, default: 0
      t.decimal :price, default: 0
      t.integer :point_price, default: 0
      t.integer :product_type, default: 1
      t.references :attachment, index: true
      t.references :product_category, index: true
      t.timestamps
    end
  end
end
