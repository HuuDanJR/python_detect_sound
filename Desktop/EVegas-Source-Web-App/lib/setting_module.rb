module SettingModule
  include CommonModule
  include DaoModule

  SETTING_ATTRIBUTE = ClassAttribute.new
  SETTING_ATTRIBUTE.clazz = Setting
  SETTING_ATTRIBUTE.object_key = "setting"
  SETTING_ATTRIBUTE.filter_params = ["search", "by_setting_key"]
  SETTING_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  SETTING_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  SETTING_ATTRIBUTE.include_object_params = {}

  def get_data_term_of_service
    result = ResultHandler.new
    data = Setting.where('setting_key = ?', 'TERM_OF_SERVICE').first
    if data.nil?
      result.set_success_data(:ok, Setting.new)
      return result
    end
    result.set_success_data(:ok, data)
    return result
  end

  def get_data_staff_note
    result = ResultHandler.new
    data = Setting.where('setting_key = ?', 'MESSAGE_STAFF_NOTE_CONFIG').first
    if data.nil?
      result.set_success_data(:ok, Setting.new)
      return result
    end
    result.set_success_data(:ok, data)
    return result
  end

  def get_data_app_domain
    result = ResultHandler.new
    data = Setting.where('setting_key = ?', 'APP_DOMAIN').first
    if data.nil?
      result.set_success_data(:ok, Setting.new)
      return result
    end
    result.set_success_data(:ok, data)
    return result
  end

  def get_data_forgot_password
    result = ResultHandler.new
    data = Setting.where('setting_key = ?', 'FORGOT_PASSSWORD_NOTIFICATION').first
    if data.nil?
      result.set_success_data(:ok, Setting.new)
      return result
    end
    result.set_success_data(:ok, data)
    return result
  end

end