module CommonModule
  require 'rest-client'
  require 'uri'

  NUMBER_PATTERN = /^[-+]?[0-9]+$/
  DATETIME_PATTERN = /^(\d{4})-(\d{2})-(\d{2})T(\d{2})\:(\d{2})\:(\d{2})\.(\d{3})(\w{1})$/
  PHOTO_EXTENSION = ["jpeg", "jpg", "gif", "tif", "png", "svg", "webp"]
  CATEGORY_ATTACHMENT = {picture: 1, document: 2}
  HOST_NAME = ENV["APP_DOMAIN"]
  PATH_API_ATTACHMENT = ENV["PATH_API_ATTACHMENT"]
  PATH_STORE_ATTACHMENT = ENV['ATTACHMENT_REPOSITORY']
  PASSWORD_DEFAULT = "123456"
  FCM_SERVER_KEY = ENV['FCM_SERVER_KEY']
  FIREBASE_CONFIG = {
    apiKey: ENV['FIREBASE_API_KEY'],
    authDomain: ENV['FIREBASE_AUTH_DOMAIN'],
    projectId: ENV['FIREBASE_PROJECT_ID'],
    storageBucket: ENV['FIREBASE_STORAGE_BUCKET'],
    messagingSenderId: ENV['FIREBASE_SENDER_ID'],
    appId: ENV['FIREBASE_APP_ID'],
    measurementId: ENV['FIREBASE_MEASUREMENT_ID'],
    validKey: ENV['FIREBASE_VALID_KEY'],
  }
  FIREBASE_JSON_CREDENTIAL = ENV['FIREBASE_JSON_CREDENTIAL']

  def is_disable_total(clazz)
    clazz_str = clazz.to_s
    DISABLE_GET_TOTAL_CLASS.each do |class_disable|
      if clazz_str == class_disable
        return true
      end
    end
    return false
  end

  PAGING_CONFIG = {
      LIMIT: ENV['PAGING_LIMIT_WEB'].to_i,
      OFFSET: 0
  }

  PAGING_CONFIG_API = {
      LIMIT: ENV['PAGING_LIMIT_API'].to_i,
      OFFSET: 0
  }

  PAGING_OFFICER_CONFIG = {
      LIMIT: ENV['PAGING_LIMIT_WEB'].to_i,
      OFFSET: 0
  }

  OBJECT_STATUS = {
      ACTIVE: 1,
      INACTIVE: 0,
      DELETE: -1
  }

  # Return a default result
  def default_result
    return JSON.parse({message: "", data: "", status: 200, result: true}.to_json)
  end

  # Render message json
  def message_json(value)
    return {message: value}
  end

  # Convert boolean strings as "true", "false", "0", "1" to boolean value
  def convert_string_to_boolean(string)
    if (string == false || string == "false" || string == "0")
      result = false
    elsif (string == true || string == "true" || string == "1")
      result = true
    else
      result = nil
    end

    return result
  end

  # Validate blank
  def is_blank(value)
    return value.blank?
  end

  # Validate number
  def is_number(value)
    if is_blank(value)
      return false
    end
    return (value.to_s =~ NUMBER_PATTERN)
  end

  def is_number_in_range(value, from_number, to_number)
    if !is_number(value) || !is_number(from_number) || !is_number(to_number)
      return false
    end
    if (value < from_number || value > to_number)
      return false
    end
    return true
  end

  # Validate boolean value string
  def is_boolean_string(value)
    result = true
    if (value.nil?)
      result = false
    elsif (value == false || value == true || value == 'false' || value == 'true' || value == '0' || value == '1')
      result = true
    else
      result = false
    end
    return result
  end

  # Check that value is a datetime with timezone
  def is_datetime(value)
    if is_blank(value)
      result = false
    elsif !(value.to_s =~ DATETIME_PATTERN)
      result = false
    else
      result = true
    end
    return result
  end

  def get_extension_file_upload(file)
    extension = file.content_type.split('/')[1]
    if (PHOTO_EXTENSION.include? (extension.downcase))
      category = CATEGORY_ATTACHMENT[:picture]
    else
      category = CATEGORY_ATTACHMENT[:document]
    end
    return category
  end

  def get_delivery_options(_address, _port, _domain, _user_name, _password, _authentication, _enable_starttls_auto)
    delivery_options = {}
    if (_authentication == 'ntlm')
      delivery_options = {
          :address => _address,
          :port => _port,
          :domain => _domain,
          :user_name => _user_name,
          :password => _password,
          :authentication => :ntlm,
          :enable_starttls_auto => true
      }
    else
      delivery_options = {
          :address => _address,
          :port => _port,
          :domain => _domain,
          :user_name => _user_name,
          :password => _password,
          :authentication => _authentication,
          :enable_starttls_auto => true
      }
    end
    return delivery_options
  end

  def convertTimestampToDateTime(timestamp)
    return (Time.at(timestamp).to_datetime).strftime("%d-%m-%Y %H:%M:%S")
  end

  # Get content from url
  def get_content_from_url(_url, _method, _payload = nil)
    result = ResultHandler.new
    begin
      response = RestClient::Request.execute(
        method: _method, 
        url: _url, 
        payload: _payload,
        headers: { :accept => :json, content_type: :json },
        timeout: ENV['TIMEOUT_REQUEST'].to_i)
      # puts JSON.parse(response.body)
      result.set_success_data(:ok, response)
    rescue RestClient::ExceptionWithResponse => err
      # puts err.response
      result.set_error_data(:service_unavailable, I18n.t('messages.can_not_connect_to_server'))
    rescue StandardError => e
      hostname = URI.parse(_url).host
      result.set_error_data(:service_unavailable, I18n.t('messages.can_not_connect_to_server') + hostname)
    end
    return result
  end

  def have_any_empty_property(arr)
    arr.each do |a|
      if is_blank(a) == true
        return true
      end
    end
    return false
  end

  def safe_date(string_date)
    date_tmp = DateTime.parse(string_date)
    return true
  rescue TypeError, ::DateTime::Error
    return false
  end
  
  def get_query_notification_by_user(user_id, id = nil)
    user = User.select('language').find(user_id)
    if id != nil
      notifi = Notification.find(id.to_i)
      if user != nil
        query_select = "'attachment_id', notifications.id, user_id, source_id, source_type, notification_type, notifications.created_at, notifications.updated_at, status_type, status, is_read, category"
        query_default = query_select + " ,title, short_description, content"

        if user.language.to_s == 'ja'
          if notifi.title_ja.present? && notifi.short_description_ja.present? && notifi.content_ja.present?
            return query_select + " , title_ja as title, short_description_ja as short_description, content_ja as content"
          end
        elsif user.language.to_s == 'ko'
          if notifi.title_kr.present? && notifi.short_description_kr.present? && notifi.content_kr.present?
            return query_select + " , title_kr as title, short_description_kr as short_description, content_kr as content"  
          end
        elsif user.language.to_s == 'zh'
          if notifi.title_cn.present? && notifi.short_description_cn.present? && notifi.content_cn.present?
            return query_select + " , title_cn as title, short_description_cn as short_description, content_cn as content"
          end
        end
        
        return query_default
      end
    end

    query_select = "notifications.id, user_id, source_id, source_type, notification_type, notifications.created_at, notifications.updated_at, status_type, status, is_read, category"
    if user != nil
      if user.language == 'ja'
        query_select = query_select + " , title_ja as title, short_description_ja as short_description, content_ja as content"
      elsif user.language == 'ko'
        query_select = query_select + " , title_kr as title, short_description_kr as short_description, content_kr as content"
      elsif user.language == 'zh'
        query_select = query_select + " , title_cn as title, short_description_cn as short_description, content_cn as content"
      else
        query_select = query_select + " , title, short_description, content"
      end
    end
    
    return query_select
  end

  def find_current_and_next_fridays(reference_date)
    # Calculate the day of the week for the reference date (0-6, where Monday is 0)
    day_of_week = reference_date.wday

    # Calculate days to last Friday
    days_to_last_friday = (day_of_week - 5) % 7
    days_to_last_friday = 7 if days_to_last_friday == 0 && reference_date.friday?
    last_friday = reference_date - days_to_last_friday

    # If the reference date is a Friday, it is considered the current Friday
    current_friday = reference_date.friday? ? reference_date : last_friday

    # Calculate next Friday
    next_friday = current_friday + 7
  
    return current_friday, next_friday
  end
  
  
end