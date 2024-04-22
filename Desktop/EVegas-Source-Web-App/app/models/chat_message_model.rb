
class ChatMessageModel
    include ActiveModel::Model
    attr_accessor :id, :content, :is_customer, :is_read, :user_id, :chat_room_id, :attachment_id, :created_at, :avatar_id
end