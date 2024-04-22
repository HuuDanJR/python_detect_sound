class CreateChatRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :chat_rooms do |t|
      t.string :name, limit: 512, default: ""

      t.timestamps
    end
  end
end
