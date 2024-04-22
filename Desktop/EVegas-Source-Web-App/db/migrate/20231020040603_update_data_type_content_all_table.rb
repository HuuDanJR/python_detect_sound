class UpdateDataTypeContentAllTable < ActiveRecord::Migration[6.0]
  def change
    change_column :notifications, :content, :text, limit: 16.megabytes - 1
    change_column :notifications, :content_ja, :text, limit: 16.megabytes - 1
    change_column :notifications, :content_kr, :text, limit: 16.megabytes - 1
    change_column :notifications, :content_cn, :text, limit: 16.megabytes - 1

    change_column :messages, :content, :text, limit: 16.megabytes - 1
    change_column :messages, :content_ja, :text, limit: 16.megabytes - 1
    change_column :messages, :content_kr, :text, limit: 16.megabytes - 1
    change_column :messages, :content_cn, :text, limit: 16.megabytes - 1
  end
end
