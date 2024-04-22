module DeviceModule
  include CommonModule
  include DaoModule

  DEVICE_ATTRIBUTE = ClassAttribute.new
  DEVICE_ATTRIBUTE.clazz = Device
  DEVICE_ATTRIBUTE.object_key = "device"
  DEVICE_ATTRIBUTE.filter_params = ["search"]
  DEVICE_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  DEVICE_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  DEVICE_ATTRIBUTE.create_params = ["user_id", "token", "device_type", "time_expired", "device_id"]
  DEVICE_ATTRIBUTE.include_object_params = {}

  def create_object(clazz, object_key, create_params)
    if params.has_key?("device_id")
      if params["device_id"].present?
        device = Device.where("device_id = ?", params["device_id"].to_s).first
        if device != nil
          device.destroy
        end
      end
    end
    object_new = clazz.new(get_data_object_request_body(object_key, create_params))
    object = clazz.where(token: object_new.token).first
    if object.nil?
      super
    else
      result = ResultHandler.new
      result.set_success_data(:ok, object)
      return result
    end
  end

  # Validate input param destroy
  def check_params_destroy(request_body)
    result = ResultHandler.new
    token_prop = request_body['token']

    if (is_blank(token_prop))
      result.set_error_data(:bad_request, I18n.t('messages.invalid_param'))
      return result
    end

    @devices = Device.where(token: token_prop)
    if (is_blank(@devices))
      result.set_error_data(:not_found, I18n.t('messages.invalid_param'))
      return result
    end

    return result
  end

  # Destroy devices with token
  def destroy_devices_with_token(devices)
    result = ResultHandler.new

    ActiveRecord::Base::transaction do
      # device_mobile = Device.where("user_id = ? AND device_type != 'web'", current_user.id).order("id desc").limit(10).offset(3)
      # if device_mobile.length > 0
      #   device_mobile.destroy_all
      # end

      devices.each do |device|
        _ok = device.destroy
        raise ActiveRecord::Rollback, result = false unless _ok
      end
    end

    return result
  end

  def syns_token_expired()
    time_expired = 7.days.from_now
    device = Device.all.where('time_expired < ?', time_expired)
    if device.length > 0
      device.each do |item|
        item.destroy
      end 
    end
  end
  
end