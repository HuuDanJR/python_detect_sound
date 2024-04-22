class AddColumnToOffer < ActiveRecord::Migration[6.0]
  def change
    add_column :offers, :index_order, :integer, default: 1
    add_column :offers, :is_discover, :boolean, null: false, default: 0
  end
end
