class AddIsHideToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :is_hide, :boolean, default: 0
  end
end
