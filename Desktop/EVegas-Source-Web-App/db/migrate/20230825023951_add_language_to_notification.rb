class AddLanguageToNotification < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :title, :string, limit: 500
    add_column :notifications, :short_description, :string, limit: 1000
  end
end
