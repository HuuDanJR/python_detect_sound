class UpdateDataTypeContentMessage < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      change_table :messages do |t|
      dir.up { t.change :content, :text, default: nil }
      dir.down { t.change :content, :string, limit: 10000 }
      end
    end
  end
end
