class RemoveIsDeleteNotification < ActiveRecord::Migration[6.0]
  def change
    remove_column :notifications, :is_delete
  end
end
