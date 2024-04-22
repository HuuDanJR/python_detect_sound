class UpdateContentNotification < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      change_table :notifications do |t|
        dir.up { t.change :content, :text, default: nil }
        dir.down { t.change :content, :string, limit: 255 }
      end
    end
  end
end
