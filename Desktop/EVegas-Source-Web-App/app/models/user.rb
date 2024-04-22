class User < ApplicationRecord
  # validates :name, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  require 'open-uri'
  require 'mini_magick'

  include CommonModule
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable,
         :omniauthable, omniauth_providers: %i[facebook]

  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups
  has_many :group_roles, through: :groups
  has_many :roles, through: :group_roles
  has_one :customer
  has_many :devices
  has_many :chat_participants
  has_many :chat_messages

  def authenticatable_salt
    "#{super}#{session_token}"
  end

  def invalidate_all_sessions!
    self.session_token = SecureRandom.hex
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      # user.name = auth.info.name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def role?(role)
    roles.any? { |r| r.name == role }
  end

  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end

  def send_notification_to_user(title, description, message_type, object_id, notifi_id, icon)
    path_icon = ""
    if icon != nil
      path_icon = HOST_NAME.to_s + PATH_API_ATTACHMENT.to_s + icon.to_s + "?version=noti"
    end
    payload = {payload: { title: title, description: description, message_type: message_type, object_id: object_id, id: notifi_id, icon: path_icon } }
    android_condition = "device_type = 'android' and user_id = #{id.to_i}"
    ios_condition = "device_type = 'ios' and user_id = #{id.to_i}"
    send_notification(payload, android_condition, 'android')
    send_notification(payload, ios_condition, 'ios')

  end

  def send_notification(payload, condition, device_type)
    tokens = Device.where(condition).pluck(:token).compact
    Device.send_notification(tokens, payload, device_type)
  end
  
  def send_notification_web(payload)
    tokens = Device.where("device_type = 'web'").pluck(:token).compact
    Device.send_notification_web(tokens, payload)
  end

  def send_message(payload, condition, device_type)
    tokens = Device.where(condition).pluck(:token).compact
    Device.send_message(tokens, payload, device_type)
  end
  
  def send_message_web(payload, user_id)
    Device.send_message_web(payload, user_id)
  end

  def send_message_to_user_mobile(user_id, title, message_type, id, notifi_id, icon, short_description, recieve_id, recieve_name)
    path_icon = ""
    if icon != nil
      path_icon = HOST_NAME.to_s + PATH_API_ATTACHMENT.to_s + icon.to_s + "?version=noti"
      # dimensions = get_image_dimensions(path_icon)
      # if dimensions[:width] <= 1024 && dimensions[:height] <= 576
      #   path_icon = HOST_NAME.to_s + PATH_API_ATTACHMENT.to_s + icon.to_s
      # else
      #   path_icon = HOST_NAME.to_s + PATH_API_ATTACHMENT.to_s + icon.to_s + "?version=noti"
      # end
    end
    chat_participant = ChatParticipant.select("chat_room_id").where(user_id: user_id )
    if chat_participant.length > 0
      count = ChatMessage.where(chat_room_id: chat_participant, is_read: 0).where.not(user_id: user_id).count
    end
    payload = {payload: { title: title, description: short_description, object_id: id, message_type: message_type, attachment_id: path_icon, room_id: notifi_id, recieve_id: recieve_id, recieve_name: recieve_name, count_message: count } }
    android_condition = "device_type = 'android' and user_id = #{user_id.to_i}"
    ios_condition = "device_type = 'ios' and user_id = #{user_id.to_i}"
    send_message(payload, android_condition, 'android')
    send_message(payload, ios_condition, 'ios')
  end

  def get_image_dimensions(url)
    image = MiniMagick::Image.open(url)
    { width: image.width, height: image.height }
  end

end
