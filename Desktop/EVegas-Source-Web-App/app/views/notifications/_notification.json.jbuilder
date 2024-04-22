json.extract! notification, :id, :user_id, :source_id, :source_type, :notification_type, :content, :created_at, :updated_at
json.url notification_url(notification, format: :json)
