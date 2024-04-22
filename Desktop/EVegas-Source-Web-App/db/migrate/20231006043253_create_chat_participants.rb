class CreateChatParticipants < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_participants do |t|

      t.references :user, index: true
      t.references :chat_room, index: true
      t.timestamps
    end
  end
end
