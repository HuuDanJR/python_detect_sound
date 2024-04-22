class AddDescriptionToPromotion < ActiveRecord::Migration[6.0]
  def change
    add_column :promotions, :description, :string, limit: 2000, default: ""
  end
end
