class AddColorToPromotion < ActiveRecord::Migration[6.0]
  def change
    add_column :promotions, :color, :string, limit: 10, default: "#ffffff"
  end
end
