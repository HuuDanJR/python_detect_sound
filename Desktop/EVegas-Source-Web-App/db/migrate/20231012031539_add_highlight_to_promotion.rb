class AddHighlightToPromotion < ActiveRecord::Migration[6.0]
  def change
    add_column :promotions, :is_highlight, :boolean, default: 0
  end
end
