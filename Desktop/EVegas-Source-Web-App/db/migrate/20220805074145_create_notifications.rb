class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, index: true
      t.integer :source_id, default: 0
      t.string :source_type, limit: 255, default: ""
      t.integer :notification_type, default: 1
      t.string :content, limit: 255, default: ""
      t.timestamps
    end
  end
end
