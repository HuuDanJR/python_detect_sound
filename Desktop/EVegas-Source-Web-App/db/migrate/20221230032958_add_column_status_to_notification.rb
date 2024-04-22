class AddColumnStatusToNotification < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :status_type, :integer, default: 1
  end
end
