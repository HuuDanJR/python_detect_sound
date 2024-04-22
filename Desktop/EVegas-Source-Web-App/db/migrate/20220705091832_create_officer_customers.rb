class CreateOfficerCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :officer_customers do |t|
      t.references :officer, null: false
      t.references :customer, null: false
      t.timestamps
    end
  end
end
