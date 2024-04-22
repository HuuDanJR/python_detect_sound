module OfficerModule
  include CommonModule
  include DaoModule

  OFFICER_ATTRIBUTE = ClassAttribute.new
  OFFICER_ATTRIBUTE.clazz = Officer
  OFFICER_ATTRIBUTE.object_key = "officer"
  OFFICER_ATTRIBUTE.filter_params = ["search"]
  OFFICER_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  OFFICER_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  OFFICER_ATTRIBUTE.include_object_params = {
      "attachment" => ["id", "name", "category"]
  }

  def validate_get_officer_by_user_id(_user_id)
    result = ResultHandler.new
    user_id = _user_id.to_i
    
    if (is_blank(user_id))
      result.set_error_data(:bad_request, I18n.t('messages.object_to_required'))
      return result
    end

    return result
  end

  def update_offline(_user_id)
    result = ResultHandler.new
    officer = Officer.where('user_id = ? AND is_reception = 0', _user_id.to_i).first
    if !officer.nil?
      officer.online = false
      officer.save!
    end
    result.set_success_data(:ok, officer)
    return result
  end

end