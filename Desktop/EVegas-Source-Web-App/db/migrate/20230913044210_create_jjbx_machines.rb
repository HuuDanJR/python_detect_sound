class CreateJjbxMachines < ActiveRecord::Migration[6.0]
  def change
    create_table :jjbx_machines do |t|
      t.string :grand_name
      t.float :grand_value
      t.string :major_name
      t.float :major_value

      t.timestamps
    end
  end
end
