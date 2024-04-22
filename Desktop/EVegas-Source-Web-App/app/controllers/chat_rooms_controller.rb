class ChatRoomsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_chat_room, only: %i[ show edit update destroy ]
  include AttachmentModule

  # GET /chat_rooms or /chat_rooms.json
  def index
    @chat_room
    # @chat_rooms = ChatRoom.all
  end

  # GET /chat_rooms/1 or /chat_rooms/1.json
  def show
  end

  # GET /chat_rooms/new
  def new
    @chat_room = ChatRoom.new
  end

  # GET /chat_rooms/1/edit
  def edit
  end

  # POST /chat_rooms or /chat_rooms.json
  def create
    @chat_room = ChatRoom.new(chat_room_params)

    respond_to do |format|
      if @chat_room.save
        format.html { redirect_to chat_room_url(@chat_room), notice: "Chat room was successfully created." }
        format.json { render :show, status: :created, location: @chat_room }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chat_room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chat_rooms/1 or /chat_rooms/1.json
  def update
    respond_to do |format|
      if @chat_room.update(chat_room_params)
        format.html { redirect_to chat_room_url(@chat_room), notice: "Chat room was successfully updated." }
        format.json { render :show, status: :ok, location: @chat_room }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chat_room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chat_rooms/1 or /chat_rooms/1.json
  def destroy
    @chat_room.destroy

    respond_to do |format|
      format.html { redirect_to chat_rooms_url, notice: "Chat room was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def chat_participants
    limit = params['limit'].to_i
    offset = params['offset'].to_i
    keyword = params['search'].to_s
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
            end
          end
          list_data.push(ChatParticipantModel.new(id: item.id, officer_id: item.officer_id, room_name: item.room_name, 
                                                  user_id: item.user_id,  last_message: last_message.content,  last_time: last_message.created_at.strftime("%H:%M %d-%m-%Y"), 
                                                  attachment_id: last_message.attachment_id, avatar_id: attachment))
        else
          customer_participant = ChatParticipant.where('chat_room_id = ? AND user_id != ?', item.id, current_user.id).first
          customer_data = Customer.where('user_id = ?', customer_participant.user_id).first
          if customer_data != nil
            attachment = customer_data.attachment_id
          end
          list_data.push(ChatParticipantModel.new(id: item.id, officer_id: item.officer_id, room_name: item.room_name, 
                                                  user_id: item.user_id,  last_message: "",  last_time: "", 
                                                  attachment_id: nil, avatar_id: attachment))
        end
      end
    end
    # if list_data.length > 0
    #   list_data = list_data.sort_by(&:last_time).reverse()
    # end
    render json: list_data
  end

  def chat_messages
    limit = params['limit'].to_i
    offset = params['offset'].to_i
    chat_room = params['chat_room'].to_i

    chat_message = ChatMessage.where("chat_room_id = ?", chat_room).order('created_at desc').limit(limit).offset(offset)
    list_data = []
    if chat_message.length > 0
      chat_message.each do |item|
        attachment = nil
        if item.is_customer
          customer = Customer.where("user_id = ?", item.user_id).first
          if customer != nil
            attachment = customer.attachment_id
          end
        else
          officer = Officer.where("user_id = ?", item.user_id).first
          if officer != nil
            attachment = officer.attachment_id
          end
        end      
        list_data.push(ChatMessageModel.new(id: item.id, content: item.content, is_customer: item.is_customer, 
        is_read: item.is_read,  user_id: item.user_id, chat_room_id: item.chat_room_id, attachment_id: item.attachment_id,
        created_at: item.created_at.strftime("%H:%M %d-%m-%Y"), avatar_id: attachment))
      end
    end

    render json: list_data.reverse()
  end

  def create_attachment_file
    attachment = get_attachment_from_request(params[:file])
    if !attachment.nil?
      result = upload_attachment(attachment)
      if (result.result == true)
        render json: result.data
        return
      end
      render nil
    else
      render nil
    end
  end

  def create_messages
    data = JSON.parse(request.body.read)
    messsage = ChatMessage.new
    messsage.content = data['content'].strip
    messsage.is_customer = false
    messsage.is_read = false
    messsage.user_id = current_user.id
    messsage.chat_room_id = data['chat_room_id'].to_i
    messsage.attachment_id = data['attachment_id']
    messsage.created_at = DateTime.now
    messsage.updated_at = DateTime.now
    if messsage.save
        chat_participant = ChatParticipant.where('user_id != ? AND chat_room_id = ?', current_user.id, messsage.chat_room_id).last
        if !chat_participant.nil?
          attachment = nil
          officer = Officer.where("user_id = ?", current_user.id).first
          if officer != nil
            attachment = officer.attachment_id
          end  

          render json: ChatMessageModel.new(id: messsage.id, content: messsage.content, is_customer: messsage.is_customer, 
          is_read: messsage.is_read,  user_id: messsage.user_id, chat_room_id: messsage.chat_room_id, attachment_id: messsage.attachment_id,
          created_at: messsage.created_at.strftime("%H:%M %d-%m-%Y"), avatar_id: attachment)
          return
        end
        render json: []
        return
    end
    render json: []
    return
  end

  def send_mesage_to_user(user_id, title, message_type, id, notifi_id, icon_id, officer_id, officer_name, short_description = "")
    user = User.find(user_id)
    user.send_message_to_user_mobile(user_id, title, message_type, id, notifi_id, icon_id, short_description, officer_id, officer_name)
  end

  def send_messages
    chat_room = params['chat_room'].to_i
    message_id = params['message_id'].to_i
    chat_participant = ChatParticipant.where('user_id != ? AND chat_room_id = ?', current_user.id, chat_room).last
    messsage = ChatMessage.where('id = ?', message_id).first
    officer = Officer.where("user_id = ?", current_user.id).first
    officer_id = nil
    officer_name = "New Message"
    if !officer.nil?
      officer_id = officer.user_id
      officer_name = officer.name
    end
    send_mesage_to_user(chat_participant.user_id, officer_name, "chat_messages", messsage.id, chat_participant.chat_room_id, messsage.attachment_id, officer_id, officer_name, messsage.content)
    render json: true
  end

  def upload_attachment_message
    # Check params require, params option, value params
    result = check_attachment_upload()
    if (result.result == false)
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    attachment = get_attachment_from_request(params[:file])

    # data = get_attachment_exist(attachment.file_hash)
    # if data != nil
    #   render_success_json(SuccessData.new(200, data))
    #   return
    # end
    
    result = upload_attachment(attachment)
    if (result.result == true)
      render json: result
    else
      render json: []
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat_room
      @chat_room = ChatRoom.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chat_room_params
      params.require(:chat_room).permit(:name)
    end
end
