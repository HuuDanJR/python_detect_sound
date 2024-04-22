class AddIndexToProductCategory < ActiveRecord::Migration[6.0]
  def change
    add_column :product_categories, :index_category, :integer, default: 1
  end
end
