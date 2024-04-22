class AddColumnDatePointToCustomer < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :frame_start_date, :datetime
    add_column :customers, :frame_end_date, :datetime
  end
end
