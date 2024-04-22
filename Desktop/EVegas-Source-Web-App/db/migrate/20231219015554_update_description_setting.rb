class UpdateDescriptionSetting < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      change_table :settings do |t|
        dir.up { t.change :description, :text, default: nil }
        dir.down { t.change :description, :string, limit: 255 }
      end
    end
  end
end
