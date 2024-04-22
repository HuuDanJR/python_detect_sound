class Api::V1::ChatRoomsController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [] # Requires access token for all actions
  before_action :authenticate_user!, only: [:get_chat_room_by_user, :create_participant, :create_room_participant, :get_chat_room_by_host, :get_count_message_unread, :get_chat_room_for_user]
  before_action :check_request_body, only: [:create_room_participant]
  include ChatRoomModule

  def initialize()
    super(CHAT_ROOM_ATTRIBUTE)
  end

  def get_chat_room_by_user
    result = ResultHandler.new
    officer_id = params[:officer_id].to_i
    result = get_data_chat_room_by_user(current_user.id, officer_id)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

  def create_room_participant
    result = ResultHandler.new
    result = create_chat_participant(current_user.id, @request_body)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

  def get_chat_room_by_host
    result = ResultHandler.new
    result = get_data_chat_room_by_host(params)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

  def get_count_message_unread 
    result = ResultHandler.new
    result = get_data_count_message_unread(current_user.id)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

  def get_chat_room_for_user
    result = ResultHandler.new
    result = get_data_chat_room_for_user(params)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

end