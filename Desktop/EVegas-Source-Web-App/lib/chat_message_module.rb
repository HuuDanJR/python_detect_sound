module ChatMessageModule
  include CommonModule
  include DaoModule

  CHAT_MESSAGE_ATTRIBUTE = ClassAttribute.new
  CHAT_MESSAGE_ATTRIBUTE.clazz = ChatMessage
  CHAT_MESSAGE_ATTRIBUTE.object_key = "chat_message"
  CHAT_MESSAGE_ATTRIBUTE.filter_params = ["search", "by_chat_room_id"]
  CHAT_MESSAGE_ATTRIBUTE.index_except_params = ["updated_at"]
  CHAT_MESSAGE_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  CHAT_MESSAGE_ATTRIBUTE.create_params = ["content", "chat_room_id", "attachment_id", "is_customer"]
  CHAT_MESSAGE_ATTRIBUTE.include_object_params = {
  }

  # Create new object and save it into database
  def create_object(clazz, object_key, create_params)
    result = ResultHandler.new
    object = clazz.new(get_data_object_request_body(object_key, create_params))
    object.user_id = current_user.id.to_i
    object.is_read = false
    # object = initialize_new_object(object)
    logger.debug "New object: #{object.attributes.inspect}"
    logger.debug "Object should be valid: #{object.valid?}"
    ActiveRecord::Base::transaction do
      if object.save
        if params["is_first"] == true
          if object.is_customer
            chat_participant = ChatParticipant.where('user_id != ? AND chat_room_id = ?', object.user_id, object.chat_room_id).last
            if chat_participant != nil
              content_chat_default = Setting.where('setting_key = ?', 'BOT_CHAT_DEFAULT').first().setting_value.to_s
              messsage_first = ChatMessage.new
              messsage_first.content = content_chat_default
              messsage_first.chat_room_id = chat_participant.chat_room_id
              messsage_first.attachment_id = nil
              messsage_first.is_customer = false
              messsage_first.is_read = false
              messsage_first.user_id = chat_participant.user_id
              if messsage_first.save
                doc = Nokogiri::HTML(messsage_first.content)
                result.set_success_data(:created, object)
                messsage_first.content = doc.text
                thread = Thread.new do
                  begin
                    # sleep(1)
                    send_notification_to_user_customer_mobile(messsage_first) if messsage_first.id
                  rescue => e
                    Rails.logger.error "Thread error: #{e.message}"
                  end
                end
                
              end
            end
          end
        else
          result.set_success_data(:created, object)
        end
        thread = Thread.new do
          begin
            # sleep(1) 
            if object.is_customer
              send_notification_to_user_mobile(object) if object.id
              send_notification_to_user_web(object) if object.id
            else
              if params["is_first"] == false
                send_notification_to_user_customer_mobile(object) if object.id
              end
            end
          rescue => e
            Rails.logger.error "Thread error: #{e.message}"
          end
        end
      else
        result.set_error_data(:unprocessable_entity, object.errors)
        raise ActiveRecord::Rollback
      end
    end

    return result
  end

  # Get all object from database
  def get_all_object_override(clazz, clazz_filter_params, input_params, query = nil, order_field = nil)
    result = ResultHandler.new

    # Get query data
    query_select = return_data_param_field(input_params['fields'])
    query_order = return_data_param_order(input_params['sort'])
    query_limit = return_data_param_limit(input_params['limit'])
    query_offset = return_data_param_offset(input_params['offset'])
    query_include = return_data_param_include(input_params['include'])

    logger.debug "Get all object: #{clazz}"
    logger.debug "Input params: #{input_params}"
    begin
      records = clazz.filter(filtering_params(params, clazz_filter_params))
      # total = records.count
      query_include.each do |item|
        records = records.includes(item)
      end
      if !query.nil?
        records = records.where(query)
      end
      query_select = query_select + ", 'officer_user_id', 'customer_user_id'"
      records = records.select(query_select)
                    .order(query_order)
                    .order(order_field)
                    # .where('user_id = ?', current_user.id)
                    .limit(query_limit)
                    .offset(query_offset)

      if records.length > 0
        officer = ChatParticipant.where("chat_room_id = ? AND officer_id IS NULL", records[0].chat_room_id).first
        customer = ChatParticipant.where("chat_room_id = ? AND officer_id IS NOT NULL", records[0].chat_room_id).first
        records.each do |item|
          item.officer_user_id = officer.user_id
          item.customer_user_id = customer.user_id
        end
      end
      # result.set_success_data_paging(:ok, records, total)
      result.set_success_data(:ok, records)
    rescue ActiveRecord::StatementInvalid => e
      result.set_error_data(:internal_server_error, e.to_s)
    rescue StandardError => e
      result.set_error_data(:internal_server_error, e.to_s)
    end

    return result
  end

  def send_notification_to_user_mobile(messsage)
    chat_participant = ChatParticipant.where('user_id != ? AND chat_room_id = ?', messsage.user_id, messsage.chat_room_id).last
    name_noti = "New Message"
    customer = Customer.where("user_id = ?", messsage.user_id).first
    if customer == nil
      customer = Customer.where("user_id != ?", messsage.user_id).first
      name_noti = customer.surname.to_s + " " + customer.forename.to_s + ' - ' + customer.number.to_s
    else
      name_noti = customer.surname.to_s + " " + customer.forename.to_s + ' - ' + customer.number.to_s
    end
    
    send_mesage_to_user_api(chat_participant.user_id, name_noti, "chat_messages", messsage.id, chat_participant.chat_room_id, messsage.attachment_id, customer.user_id, customer.forename, messsage.content)
  end

  def send_notification_to_user_customer_mobile(messsage)
    chat_participant = ChatParticipant.where('user_id != ? AND chat_room_id = ?', messsage.user_id, messsage.chat_room_id).last
    name_noti = "New Message"
    officer = Officer.where("user_id = ?", messsage.user_id).first
    if officer == nil
      officer = Officer.where("user_id != ?", messsage.user_id).first
      name_noti = officer.name
    else
      name_noti = officer.name
    end
    

    send_mesage_to_user_api(chat_participant.user_id, name_noti, "chat_messages", messsage.id, chat_participant.chat_room_id, messsage.attachment_id, officer.user_id, officer.name, messsage.content)
  end

  def send_notification_to_user_web(object)
    attachment = nil
    customer = Customer.where("user_id = ?", object.user_id).first
    if customer != nil
      attachment = customer.attachment_id
    end
    user_id_receive = nil
    last_officer_chat = ChatMessage.where('chat_room_id = ? AND is_customer = 0', object.chat_room_id).last
    if last_officer_chat != nil
      user_id_receive = last_officer_chat.user_id
    else
      chat_participant = ChatParticipant.where('user_id != ? AND chat_room_id = ?', object.user_id, object.chat_room_id).last
      
      user_id_receive = chat_participant.user_id
    end
    chat_room = ChatRoom.where('id = ? ', object.chat_room_id).first
    chat_message = ChatMessageModel.new(id: object.id, content: object.content, is_customer: object.is_customer, 
        is_read: object.is_read,  user_id: object.user_id, chat_room_id: object.chat_room_id, attachment_id: object.attachment_id,
        created_at: object.created_at.strftime("%H:%M %d-%m-%Y"), avatar_id: attachment)
    send_message_to_user_web("New Message", "chat_messages", chat_message, user_id_receive, object.chat_room_id, chat_room.name)
  end

  def send_message_to_user_web(title, object_type, chat_message, user_id, chat_room_id, chat_room)
    user = User.find(user_id)
    payload = {payload: { title: title, message_type: object_type, messsage: chat_message, chat_room: chat_room, chat_room_id: chat_room_id } }
    user.send_message_web(payload, user_id)
  end

  def send_mesage_to_user_api(user_id, title, message_type, id, notifi_id, icon_id, recieve_id, recieve_name, short_description = "")
    user = User.find(user_id)
    user.send_message_to_user_mobile(user_id, title, message_type, id, notifi_id, icon_id, short_description, recieve_id, recieve_name)
  end

  def update_all_read(_user_id, _room_id)
    chat_mess = ChatMessage.where(chat_room_id: _room_id.to_i).where.not(user_id: _user_id)
    if chat_mess.length > 0
      chat_mess = chat_mess.update_all(is_read: 1)
    end
  end

  def check_request_read_message(message_id)
    result = ResultHandler.new
    id_prop = message_id

    if (is_blank(id_prop))
      result.set_error_data(:bad_request, I18n.t('messages.invalid_param'))
      return result
    end

    message = ChatMessage.where(id: id_prop.to_i).first
    if (message == nil)
      result.set_error_data(:not_found, I18n.t('messages.invalid_param'))
      return result
    end

    return result
  end

  def update_read_message_by_id(_user_id, _message_id)
    result = ResultHandler.new
    message = ChatMessage.where(id: _message_id.to_i).first
    if message != nil
      message.is_read = true
      message.save
      update_all_read(_user_id, message.chat_room_id)
    end
    
    result.set_success_data(:ok, message)
    return result
  end
end