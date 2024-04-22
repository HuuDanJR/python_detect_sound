class CreateOrderProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :order_products do |t|
      t.references :order, null: false, index: true
      t.references :product, null: false, index: true
      t.integer :quantity
      t.decimal :unit_price
      t.decimal :sub_total
      t.timestamps
    end
  end
end
