class CreateCarts < ActiveRecord::Migration[6.0]
  def change
    create_table :carts do |t|
      t.references :customer, null: false, index: true
      t.references :product, null: false, index: true
      t.integer :quantity
      t.timestamps
    end
  end
end
