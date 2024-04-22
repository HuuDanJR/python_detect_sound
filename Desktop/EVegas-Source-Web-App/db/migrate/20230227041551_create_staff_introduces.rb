class CreateStaffIntroduces < ActiveRecord::Migration[6.0]
  def change
    create_table :staff_introduces do |t|
      t.integer :customer_number, default: 0
      t.string :customer_name, limit: 200, default: ""
      t.references :staff, index: true
      t.timestamps
    end
  end
end
