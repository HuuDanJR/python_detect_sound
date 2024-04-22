class ChatMessage < ApplicationRecord
    belongs_to :chat_room, optional: true
    belongs_to :user, optional: true
    
    scope :by_chat_room_id, -> (chat_room_id) {where chat_room_id: chat_room_id}
end
