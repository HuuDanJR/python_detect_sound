class UpdateColumnValueJjbxMachine < ActiveRecord::Migration[6.0]
  def change
    change_column :jjbx_machines, :grand_value, :decimal, :precision => 15, :scale => 2
    change_column :jjbx_machines, :major_value, :decimal, :precision => 15, :scale => 2
  end
end
