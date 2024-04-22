require 'fcm'

module PushMessengerModule
  class Gcm
    include CommonModule
    def deliver(app, tokens, payload, expiry=1.day.to_i)
      tokens = *tokens
      # puts payload
      fcm_client = FCM.new(FCM_SERVER_KEY, StringIO.new(FIREBASE_JSON_CREDENTIAL), FIREBASE_CONFIG[:projectId]) # set your FCM_SERVER_KEY
      options = { 
         priority: 'high',
         data: { 
           message: payload[:payload][:description],
           type: payload[:payload][:message_type],
           object_id: payload[:payload][:object_id],
           image: payload[:payload][:icon],
           id:  payload[:payload][:id]
         },
         notification: {
            title: payload[:payload][:title],
            body: payload[:payload][:description],
            sound: 'default',
            image: payload[:payload][:icon],
            id:  payload[:payload][:id]
         }
      }
      destroy_item = PushMessengerModule::Destroy_Not_Registered.new
      tokens.each do |token|
        response = fcm_client.send(token, options)
        destroy_item.destroy_token_not_registered(token, response)
      end
    end

    def deliver_message(app, tokens, payload, expiry=1.day.to_i)
      tokens = *tokens
      # puts payload
      fcm_client = FCM.new(FCM_SERVER_KEY, StringIO.new(FIREBASE_JSON_CREDENTIAL), FIREBASE_CONFIG[:projectId]) # set your FCM_SERVER_KEY
      options = { 
         priority: 'high',
         data: { 
           message: payload[:payload][:description],
           type: payload[:payload][:message_type],
           object_id: payload[:payload][:object_id],
           image: payload[:payload][:attachment_id],
           recieve_id: payload[:payload][:recieve_id],
           recieve_name: payload[:payload][:recieve_name]
         },
         notification: {
            title: payload[:payload][:title],
            body: payload[:payload][:description],
            sound: 'notification_sound.wav',
            image: payload[:payload][:attachment_id],
            recieve_id: payload[:payload][:recieve_id],
            recieve_name: payload[:payload][:recieve_name],
            badge: payload[:payload][:count_message]
         }
      }
      destroy_item = PushMessengerModule::Destroy_Not_Registered.new
      tokens.each do |token|
        response = fcm_client.send(token, options)
        destroy_item.destroy_token_not_registered(token, response)
      end
    end
  end

  class Ios
    include CommonModule
    def deliver(app, tokens, payload)
      tokens = *tokens
      # puts payload
      fcm_client = FCM.new(FCM_SERVER_KEY, StringIO.new(FIREBASE_JSON_CREDENTIAL), FIREBASE_CONFIG[:projectId]) # set your FCM_SERVER_KEY
      options = { 
         priority: 'high',
         data: { 
           message: payload[:payload][:description],
           type: payload[:payload][:message_type],
           object_id: payload[:payload][:object_id],
           image: payload[:payload][:icon],
           id:  payload[:payload][:id]
         },
         notification: {
            title: payload[:payload][:title],
            body: payload[:payload][:description],
            sound: 'default',
            image: payload[:payload][:icon],
            id:  payload[:payload][:id]
         }
      }
      destroy_item = PushMessengerModule::Destroy_Not_Registered.new
      tokens.each do |token|
        response = fcm_client.send(token, options)
        destroy_item.destroy_token_not_registered(token, response)
        # puts response.to_json
      end
    end

    def deliver_message(app, tokens, payload)
      tokens = *tokens
      # puts payload
      fcm_client = FCM.new(FCM_SERVER_KEY, StringIO.new(FIREBASE_JSON_CREDENTIAL), FIREBASE_CONFIG[:projectId]) # set your FCM_SERVER_KEY
      options = { 
         priority: 'high',
         data: { 
           message: payload[:payload][:description],
           type: payload[:payload][:message_type],
           object_id: payload[:payload][:object_id],
           image: payload[:payload][:attachment_id],
           recieve_id: payload[:payload][:recieve_id],
           recieve_name: payload[:payload][:recieve_name]
         },
         notification: {
            title: payload[:payload][:title],
            body: payload[:payload][:description],
            sound: 'notification_sound.wav',
            image: payload[:payload][:attachment_id],
            recieve_id: payload[:payload][:recieve_id],
            recieve_name: payload[:payload][:recieve_name],
            mutable_content: 1,
            badge: payload[:payload][:count_message]
         }
      }
      destroy_item = PushMessengerModule::Destroy_Not_Registered.new
      tokens.each do |token|
        response = fcm_client.send(token, options)
        destroy_item.destroy_token_not_registered(token, response)
      end
    end
  end

  class Web
    include CommonModule
    def deliver(token, payload)
      fcm_client = FCM.new(FCM_SERVER_KEY, StringIO.new(FIREBASE_JSON_CREDENTIAL), FIREBASE_CONFIG[:projectId]) # set your FCM_SERVER_KEY
      options = { 
        priority: 'high',
        data: { 
          message: payload[:payload][:description],
          type: payload[:payload][:message_type],
          object_id: payload[:payload][:object_id]
        },
        notification: {
           title: payload[:payload][:title],
           body: payload[:payload][:description],
           sound: 'default',
           icon: payload[:payload][:icon]
        }
      }
      destroy_item = PushMessengerModule::Destroy_Not_Registered.new
      if token == nil
        #send all user online in web
        time_expired = DateTime.now
        tokens = Device.where("device_type = 'web' AND time_expired >= ?", time_expired).select("token")
        tokens.each do |token_item|
          response = fcm_client.send(token_item.token, options)
          destroy_item.destroy_token_not_registered(token, response)
        end
      else
        response = fcm_client.send(token, options)
        destroy_item.destroy_token_not_registered(token, response)
      end
    end

    def deliver_message(payload, user_id)
      fcm_client = FCM.new(FCM_SERVER_KEY, StringIO.new(FIREBASE_JSON_CREDENTIAL), FIREBASE_CONFIG[:projectId]) # set your FCM_SERVER_KEY
      options = { 
        priority: 'high',
        data: { 
          message: payload[:payload][:title],
          type: payload[:payload][:message_type],
          data_chat: payload[:payload][:messsage].to_json,
          room_name: payload[:payload][:chat_room].to_s
        },
        notification: {
           title: payload[:payload][:title],
           body: payload[:payload][:title],
           sound: 'default'
        }
      }
      destroy_item = PushMessengerModule::Destroy_Not_Registered.new
      #send all user online in web
      time_expired = DateTime.now
      tokens = Device.where("device_type = 'web' AND time_expired >= ? AND user_id = ?", time_expired, user_id.to_i).select("token")
      tokens.each do |token_item|
        response = fcm_client.send(token_item.token, options)
        destroy_item.destroy_token_not_registered(token, response)
        # response.to_json
      end
    end

  end

  class Destroy_Not_Registered
    def destroy_token_not_registered(token, response)
      parsed_response = response.is_a?(String) ? JSON.parse(response) : response
      parsed_response = parsed_response[:body]
      parsed_data = parsed_response.is_a?(String) ? JSON.parse(parsed_response) : parsed_response

      if parsed_data["failure"].to_i > 0
        # Assuming there's only one result, but you might loop through all results in a real scenario
        error = parsed_data["results"].first["error"]
        
        if error == "NotRegistered"
          token_device = Device.where('token = ?', token).first
          if token_device
            token_device.destroy
          end
        end
      end
    end
  end
end