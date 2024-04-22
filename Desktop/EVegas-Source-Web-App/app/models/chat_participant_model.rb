
class ChatParticipantModel
    include ActiveModel::Model
    attr_accessor :id, :officer_id, :room_name, :user_id, :last_message, :last_time, :attachment_id, :avatar_id, :is_read, :count_unread, :officer_user_id
end