class ChatRoom < ApplicationRecord
    has_many :chat_messages
    has_many :chat_participants
end
