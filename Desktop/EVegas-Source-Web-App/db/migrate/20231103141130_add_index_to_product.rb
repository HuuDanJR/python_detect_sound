class AddIndexToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :index_product, :integer, default: 1
  end
end
