
class NotificationModel
    include ActiveModel::Model
    attr_accessor :id, :user_id, :source_id, :source_type, :notification_type, :created_at, :updated_at, :status_type, :status, :is_read, :category , :title, :short_description, :content
end