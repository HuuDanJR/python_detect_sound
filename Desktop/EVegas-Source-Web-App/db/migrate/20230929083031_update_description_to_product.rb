class UpdateDescriptionToProduct < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :desc
    add_column :products, :description, :text 
  end
end
