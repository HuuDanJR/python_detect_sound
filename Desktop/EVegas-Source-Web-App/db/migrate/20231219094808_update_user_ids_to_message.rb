class UpdateUserIdsToMessage < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      change_table :messages do |t|
        dir.up { t.change :user_ids, :text }
        dir.down { t.change :user_ids, :string, limit: 512 }
      end
    end
  end
end
