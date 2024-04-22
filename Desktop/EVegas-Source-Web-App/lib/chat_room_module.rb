module ChatRoomModule
  include CommonModule
  include DaoModule
  include ChatMessageModule

  CHAT_ROOM_ATTRIBUTE = ClassAttribute.new
  CHAT_ROOM_ATTRIBUTE.clazz = ChatRoom
  CHAT_ROOM_ATTRIBUTE.object_key = "chat_room"
  CHAT_ROOM_ATTRIBUTE.filter_params = ["search", "by_customer"]
  CHAT_ROOM_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  CHAT_ROOM_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  CHAT_ROOM_ATTRIBUTE.create_params = ["name"]
  CHAT_ROOM_ATTRIBUTE.include_object_params = {
  }

  def get_data_chat_room_by_user(user_id, officer_id)
    result = ResultHandler.new
    officer = Officer.where('user_id = ?', officer_id.to_i).first
    if officer != nil
      chat_messages = ChatRoom.joins(:chat_participants).where("user_id = ? AND officer_id = ?", user_id.to_i, officer.id.to_i).first
    else
      chat_messages = nil
    end
    
    result.set_success_data(:ok, chat_messages)
    
    return result
  end

  def create_chat_participant(user_id, request_body)
    result = ResultHandler.new
    chat_name = request_body['name'].to_s
    officer_id = request_body['officer_id'].to_i
    chat_room_existed = ChatRoom.joins(:chat_participants).where("user_id = ? AND officer_id = ?", user_id.to_i, officer_id.to_i).first
    if chat_room_existed != nil
      result.set_success_data(:ok, chat_room_existed)
      return result
    end
    chat_room = ChatRoom.new
    chat_room.name = chat_name
    
    ActiveRecord::Base::transaction do
      if chat_room.save
        chat_participant = ChatParticipant.new
        chat_participant.chat_room_id = chat_room.id
        chat_participant.user_id = current_user.id.to_i
        chat_participant.officer_id = officer_id
        if chat_participant.save
          
          officer_item = Officer.where('id = ?', chat_participant.officer_id).first
          if officer_item != nil
            officer_participant = ChatParticipant.new
            officer_participant.chat_room_id = chat_room.id
            officer_participant.user_id = officer_item.user_id
            officer_participant.officer_id = nil
            officer_participant.save!
          end
          # send_message_to_user_web("New Chat", "chat_rooms", "New #{chat_name} in chat room", officer_item.user_id, chat_room.id, chat_room.name)
        end
        result.set_success_data(:ok, chat_room)
      else
        result.set_error_data(:unprocessable_entity, chat_room.errors)
        raise ActiveRecord::Rollback
      end
    end

    result.set_success_data(:ok, chat_room)
    return result  
  end

  def get_data_chat_room_by_host(params)
    result = ResultHandler.new
    limit = params['limit'].to_i
    offset = params['offset'].to_i
    keyword = params['search'].to_s
    chat_rooms_relation = []
    if is_blank(keyword)
      chat_rooms_relation = ChatRoom.joins(:chat_participants, :chat_messages).where('chat_participants.user_id = ? ', current_user.id)
                            .select('chat_rooms.id, chat_rooms.name as room_name, chat_participants.user_id, chat_participants.officer_id')
                            .order('chat_messages.created_at desc').uniq()[offset, limit]
    else
      chat_rooms_relation = ChatRoom.joins(:chat_participants, :chat_messages).where('chat_participants.user_id = ? AND chat_rooms.name LIKE ?', current_user.id, "%#{keyword}%")
                            .select('chat_rooms.id, chat_rooms.name as room_name, chat_participants.user_id, chat_participants.officer_id')
                            .order('chat_messages.created_at desc').uniq()[offset, limit]
    end

    chat_rooms = chat_rooms_relation.to_a
    list_data = []
    if chat_rooms.length > 0
      chat_rooms.each do |item|
        last_message = ChatMessage.where('chat_room_id = ?', item.id).last
         
        if last_message != nil
          attachment = nil
          last_customer_chat = ChatMessage.where('chat_room_id = ? AND is_customer = 1', item.id).last
          if last_customer_chat != nil
            customer = Customer.where("user_id = ?", last_customer_chat.user_id).first
            if customer != nil
              attachment = customer.attachment_id
              count_unread = ChatMessage.where('chat_room_id = ? AND is_customer = 1 AND is_read = 0', item.id).count
              list_data.push(ChatParticipantModel.new(id: item.id, officer_id: current_user.id, room_name: item.room_name, 
                user_id: customer.user_id,  last_message: last_message.content,  last_time: last_message.created_at, 
                attachment_id: last_message.attachment_id, avatar_id: attachment, is_read: last_message.is_read, count_unread: count_unread))
            end
          else
          end
        else
          customer_participant = ChatParticipant.where('chat_room_id = ? ', item.id).first
          customer_data = Customer.where('user_id = ?', customer_participant.user_id).first
          if customer_data != nil
            attachment = customer_data.attachment_id
          end
          list_data.push(ChatParticipantModel.new(id: item.id, officer_id: current_user.id, room_name: item.room_name, 
                                                  user_id: item.user_id,  last_message: "",  last_time: "", 
                                                  attachment_id: nil, avatar_id: attachment, is_read: false, count_unread: 0))
        end
      end
    end
    if list_data.length > 0
      list_data = list_data.sort_by(&:last_time).reverse()
    end
    result.set_success_data(:ok, list_data)
    return result
  end

  def get_data_count_message_unread(user_id)
    result = ResultHandler.new
    count = 0
    chat_participant = ChatParticipant.select("chat_room_id").where(user_id: user_id )
    if chat_participant.length > 0
      count = ChatMessage.where(chat_room_id: chat_participant, is_read: 0).where.not(user_id: user_id).count
    end
    result.set_success_data(:ok, {total: count})
    return result
  end

  def get_data_chat_room_for_user(params)
    result = ResultHandler.new
    limit = params['limit'].to_i
    offset = params['offset'].to_i
    keyword = params['search'].to_s
    chat_rooms_relation = []
    if is_blank(keyword)
      chat_rooms_relation = ChatRoom.joins(:chat_participants, :chat_messages).where('chat_participants.user_id = ? ', current_user.id)
                            .select('chat_rooms.id, chat_rooms.name as room_name, chat_participants.user_id, chat_participants.officer_id')
                            .order('chat_messages.created_at desc').uniq()[offset, limit]
    else
      chat_rooms_relation = ChatRoom.joins(:chat_participants, :chat_messages).where('chat_participants.user_id = ? AND chat_rooms.name LIKE ?', current_user.id, "%#{keyword}%")
                            .select('chat_rooms.id, chat_rooms.name as room_name, chat_participants.user_id, chat_participants.officer_id')
                            .order('chat_messages.created_at desc').uniq()[offset, limit]
    end

    chat_rooms = chat_rooms_relation.to_a
    list_data = []
    if chat_rooms.length > 0
      chat_rooms.each do |item|
        last_message = ChatMessage.where('chat_room_id = ?', item.id).last
         
        if last_message != nil
          attachment = nil
          last_officer_chat = ChatMessage.where('chat_room_id = ? AND is_customer = 0', item.id).last
          if last_officer_chat != nil
            officer = Officer.where("user_id = ?", last_officer_chat.user_id).first
            if officer != nil
              attachment = officer.attachment_id 
              count_unread = ChatMessage.where('chat_room_id = ? AND is_customer = 0 AND is_read = 0 AND user_id != ?', item.id, current_user.id.to_i).count
              list_data.push(ChatParticipantModel.new(id: item.id, officer_id: officer.id, room_name: officer.name, 
                user_id: current_user.id,  last_message: last_message.content,  last_time: last_message.created_at.strftime("%H:%M %d-%m-%Y"), 
                attachment_id: last_message.attachment_id, avatar_id: attachment, is_read: last_message.is_read, count_unread: count_unread.to_i, officer_user_id: officer.user_id))
            else
              chat_participant_item = ChatParticipant.where('chat_room_id = ? AND user_id != ?', item.id, current_user.id).first
              if chat_participant_item != nil
                officer_tmp = Officer.where("user_id = ?", chat_participant_item.user_id).first
                if officer_tmp != nil
                  count_unread = ChatMessage.where('chat_room_id = ? AND is_customer = 0 AND is_read = 0 AND user_id != ?', item.id, current_user.id.to_i).count
                  list_data.push(ChatParticipantModel.new(id: item.id, officer_id: officer_tmp.id, room_name: officer_tmp.name, 
                    user_id: current_user.id,  last_message: last_message.content,  last_time: last_message.created_at.strftime("%H:%M %d-%m-%Y"), 
                    attachment_id: last_message.attachment_id, avatar_id: attachment, is_read: last_message.is_read, count_unread: count_unread.to_i, officer_user_id: officer_tmp.user_id))
                end
              end
            end

          else
            chat_participant_item = ChatParticipant.where('chat_room_id = ? AND user_id != ?', item.id, current_user.id).first
            if chat_participant_item != nil
              officer_tmp = Officer.where("user_id = ?", chat_participant_item.user_id).first
              if officer_tmp != nil
                list_data.push(ChatParticipantModel.new(id: item.id, officer_id: officer_tmp.id, room_name: officer_tmp.name, 
                  user_id: current_user.id,  last_message: last_message.content,  last_time: last_message.created_at.strftime("%H:%M %d-%m-%Y"), 
                  attachment_id: last_message.attachment_id, avatar_id: attachment, is_read: last_message.is_read, count_unread: 0, officer_user_id: officer_tmp.user_id))
              end
            end
          end
          
        end
      end
    end
    if list_data.length > 0
      # list_data = list_data.sort_by(&:last_time).reverse()
    end
    result.set_success_data(:ok, list_data)
    return result
  end
   
end