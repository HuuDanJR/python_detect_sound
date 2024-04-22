class Device < ApplicationRecord
    belongs_to :user

    def self.send_notification(tokens, payload, device_type='android')
        messenger = (device_type == 'android' ? PushMessengerModule::Gcm.new : PushMessengerModule::Ios.new)
        begin
          messenger.deliver("#{device_type}_app", tokens, payload)
        rescue Exception => error
          Rails.logger.debug error
        end
    end

    def self.send_notification_web(token, payload)
      messenger = PushMessengerModule::Web.new
      begin
        messenger.deliver(token, payload)
      rescue Exception => error
        Rails.logger.debug error
      end
    end

    def self.send_message(tokens, payload, device_type='android')
      messenger = (device_type == 'android' ? PushMessengerModule::Gcm.new : PushMessengerModule::Ios.new)
      begin
        messenger.deliver_message("#{device_type}_app", tokens, payload)
      rescue Exception => error
        Rails.logger.debug error
      end
    end

    def self.send_message_web(payload, user_id)
      messenger = PushMessengerModule::Web.new
      begin
        messenger.deliver_message(payload, user_id)
      rescue Exception => error
        Rails.logger.debug error
      end
    end
end
