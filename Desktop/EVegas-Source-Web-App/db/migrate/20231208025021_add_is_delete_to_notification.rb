class AddIsDeleteToNotification < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :is_delete, :integer, default: 0, index: true
  end
end
