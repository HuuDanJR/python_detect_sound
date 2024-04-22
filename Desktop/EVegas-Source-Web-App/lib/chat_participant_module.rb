module ChatParticipantModule
  include CommonModule
  include DaoModule

  CHAT_PARTICIPANT_ATTRIBUTE = ClassAttribute.new
  CHAT_PARTICIPANT_ATTRIBUTE.clazz = ChatParticipant
  CHAT_PARTICIPANT_ATTRIBUTE.object_key = "chat_participant"
  CHAT_PARTICIPANT_ATTRIBUTE.filter_params = ["search", "by_customer"]
  CHAT_PARTICIPANT_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  CHAT_PARTICIPANT_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  CHAT_PARTICIPANT_ATTRIBUTE.include_object_params = {
  }
  
  # Get a object by id
  def get_object_by_id_override(clazz, id, input_params = nil)
    query_select = nil
    query_include = []

    if !input_params.nil?
      query_select = return_data_param_field(input_params['fields'])
      query_include = return_data_param_include(input_params['include'])
    end

    return get_object_by_id_abstract_override(clazz, id, query_select, query_include)
  end

  def get_object_by_id_abstract_override(clazz, id, select_params = nil, query_include = [])
    result = ResultHandler.new

    # Get query data
    query_select = '*'
    if !select_params.nil?
      query_select = select_params
    end

    logger.debug "Get object by id: #{clazz} - #{id}"
    logger.debug "Query select: #{query_select}"
    begin
      record = clazz.select(query_select)
      if record.nil?
        result.set_error_data(:not_found, I18n.t('messages.object_not_found'))
      else
        query_include.each do |item|
          record = record.includes(item)
        end
        record = record.find(id)
        result.set_success_data(:ok, record)
      end
    rescue ActiveRecord::StatementInvalid => e
      result.set_error_data(:internal_server_error, e.to_s)
    rescue StandardError => e
      if e.to_s.include? "Couldn't find"
        result.set_error_data(:not_found, e.to_s)
      else
        result.set_error_data(:internal_server_error, e.to_s)
      end
    end

    return result
  end

end