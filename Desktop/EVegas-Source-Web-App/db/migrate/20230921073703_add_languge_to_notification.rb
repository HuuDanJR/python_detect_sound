class AddLangugeToNotification < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :content_vi, :text 
    add_column :notifications, :content_kr, :text
    add_column :notifications, :content_cn, :text
    add_column :notifications, :title_vi, :string, limit: 500
    add_column :notifications, :title_kr, :string, limit: 500
    add_column :notifications, :title_cn, :string, limit: 500
    add_column :notifications, :short_description_vi, :string, limit: 1000
    add_column :notifications, :short_description_kr, :string, limit: 1000
    add_column :notifications, :short_description_cn, :string, limit: 1000
    add_column :notifications, :language, :string, limit: 50
    add_column :notifications, :is_draft, :boolean, default: 0
    add_column :notifications, :category, :integer, default: 1
  end
end
