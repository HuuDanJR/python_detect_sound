class AddColumnLastUpdateFramePointToCustomer < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :last_update_frame_point, :datetime
  end
end
