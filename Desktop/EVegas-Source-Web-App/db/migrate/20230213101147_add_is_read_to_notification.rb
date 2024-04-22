class AddIsReadToNotification < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :is_read, :boolean, default: 0
  end
end
