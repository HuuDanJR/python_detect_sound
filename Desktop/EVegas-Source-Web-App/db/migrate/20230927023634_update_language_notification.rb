class UpdateLanguageNotification < ActiveRecord::Migration[6.0]
  def change
    rename_column :notifications, :title_vi, :title_ja
    rename_column :notifications, :content_vi, :content_ja
    rename_column :notifications, :short_description_vi, :short_description_ja
    remove_column :notifications, :language
    remove_column :notifications, :is_draft

    rename_column :messages, :title_vi, :title_ja
    rename_column :messages, :content_vi, :content_ja
    rename_column :messages, :short_description_vi, :short_description_ja
  end
end
