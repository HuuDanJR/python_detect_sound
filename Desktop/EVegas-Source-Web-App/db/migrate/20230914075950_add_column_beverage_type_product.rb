class AddColumnBeverageTypeProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :beverage_type, :integer, :default => :null
  end
end
