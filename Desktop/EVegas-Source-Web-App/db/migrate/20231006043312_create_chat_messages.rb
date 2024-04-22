class CreateChatMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_messages do |t|
      t.text :content
      t.boolean :is_customer
      t.boolean :is_read

      t.references :user, index: true
      t.references :chat_room, index: true
      t.references :attachment, index: true
      t.timestamps
    end
  end
end
