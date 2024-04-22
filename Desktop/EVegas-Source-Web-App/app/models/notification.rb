class Notification < ApplicationRecord
  belongs_to :user
  
  scope :by_user, -> (user) {where user_id: user}
  scope :by_notification_type, -> (notification_type) {where("notification_type IN (#{notification_type})")}
  scope :by_status, -> (status) {where status: status}
  scope :by_is_read, -> (is_read) {where is_read: is_read}
  scope :by_source_id, -> (source_id) {where source_id: source_id}
  scope :by_created_at, -> (by_created_at) {where("created_at >= ?", by_created_at)}
end
