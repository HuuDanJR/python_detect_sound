class AddCustomerLevelToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :customer_level, :string
  end
end
