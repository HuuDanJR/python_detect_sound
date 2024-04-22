class UpdateMessage < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      change_table :messages do |t|
        dir.up { t.change :content, :string, default: "", limit: 10000 }
        dir.down { t.change :content, :string, limit: 255 }
      end
    end
    add_column :messages, :title, :string, default: "", limit: 255
  end
end
