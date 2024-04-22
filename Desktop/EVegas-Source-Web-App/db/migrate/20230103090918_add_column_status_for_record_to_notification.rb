class AddColumnStatusForRecordToNotification < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :status, :integer, default: 1
  end
end
