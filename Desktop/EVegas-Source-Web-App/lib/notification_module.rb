module NotificationModule
  require 'roo'
  include ActionView::Helpers::NumberHelper
  include CommonModule
  include DaoModule

  NOTIFICATION_ATTRIBUTE = ClassAttribute.new
  NOTIFICATION_ATTRIBUTE.clazz = Notification
  NOTIFICATION_ATTRIBUTE.object_key = "notification"
  NOTIFICATION_ATTRIBUTE.filter_params = ["search", "by_user", "by_notification_type", "by_status", "by_is_read", "by_source_id", "by_created_at"]
  NOTIFICATION_ATTRIBUTE.index_except_params = ["updated_at"]
  NOTIFICATION_ATTRIBUTE.show_except_params = ["updated_at"]
  NOTIFICATION_ATTRIBUTE.include_object_params = {}

  def get_all_object_override(clazz, clazz_filter_params, input_params, query = nil, order_field = nil)
    result = ResultHandler.new
    # query_select = get_query_notification_by_user(current_user.id)
    
    query_select = return_data_param_field(input_params['fields'])
    query_order = return_data_param_order(input_params['sort'])
    query_limit = return_data_param_limit(input_params['limit'])
    query_offset = return_data_param_offset(input_params['offset'])
    query_include = return_data_param_include(input_params['include'])

    logger.debug "Get all object: #{clazz}"
    logger.debug "Input params: #{input_params}"
    begin
      records = clazz.filter(filtering_params(params, clazz_filter_params))
      query_include.each do |item|
        records = records.includes(item)
      end
      if !query.nil?
        records = records.where(query)
      end
      records = records.select(query_select).order(query_order)
                    .order(order_field)
                    .limit(query_limit)
                    .offset(query_offset)
      list_data = []
      user = User.select('language').find(current_user.id)
      if records.length > 0
        records.each do |item|
          if item.title_ja.present? && item.short_description_ja.present? && item.content_ja.present? && user.language.to_s == 'ja'
            list_data.push(NotificationModel.new(id: item.id, user_id: item.user_id, source_id: item.source_id, source_type: item.source_type, 
            notification_type: item.notification_type, created_at: item.created_at, updated_at: item.updated_at, status_type: item.status_type, 
            status: item.status, is_read: item.is_read, category: item.category, title: item.title_ja, short_description: item.short_description_ja, content: ""))
          elsif item.title_kr.present? && item.short_description_kr.present? && item.content_kr.present? && user.language.to_s == 'ko'
            list_data.push(NotificationModel.new(id: item.id, user_id: item.user_id, source_id: item.source_id, source_type: item.source_type, 
            notification_type: item.notification_type, created_at: item.created_at, updated_at: item.updated_at, status_type: item.status_type, 
            status: item.status, is_read: item.is_read, category: item.category, title: item.title_kr, short_description: item.short_description_kr, content: ""))
          elsif item.title_cn.present? && item.short_description_cn.present? && item.content_cn.present? && user.language.to_s == 'zh'
            list_data.push(NotificationModel.new(id: item.id, user_id: item.user_id, source_id: item.source_id, source_type: item.source_type, 
            notification_type: item.notification_type, created_at: item.created_at, updated_at: item.updated_at, status_type: item.status_type, 
            status: item.status, is_read: item.is_read, category: item.category, title: item.title_cn, short_description: item.short_description_cn, content: ""))
          else
            list_data.push(NotificationModel.new(id: item.id, user_id: item.user_id, source_id: item.source_id, source_type: item.source_type, 
            notification_type: item.notification_type, created_at: item.created_at, updated_at: item.updated_at, status_type: item.status_type, 
            status: item.status, is_read: item.is_read, category: item.category, title: item.title, short_description: item.short_description, content: ""))
          end
        end
      end
      result.set_success_data(:ok, list_data)
    rescue ActiveRecord::StatementInvalid => e
      result.set_error_data(:internal_server_error, e.to_s)
    rescue StandardError => e
      result.set_error_data(:internal_server_error, e.to_s)
    end

    return result
  end

  # Send notification to user (message)
  def send_notification_to_user(user_id, title, message_type, id, notifi_id, icon_id, short_description = "")
    user = User.find(user_id)
    # setting = Setting.where('setting_key = ?', 'TITLE_APP_NOTIFICATION').first()
    # noti_title = "E-VG Caravelle"
    # if setting != nil
    #   noti_title = setting.setting_value
    # end
    user.send_notification_to_user(title, short_description, message_type, id, notifi_id, icon_id)
  end

  # Send notification to user web
  def send_notification_to_user_web(title, message, message_type, id, token = nil)
    payload = {payload: { title: title, description: message, message_type: message_type, object_id: id } }
    # tokens = Device.where("device_type = 'web'").pluck(:token).compact
    Device.send_notification_web(token, payload)
  end

  def check_request_status(request_body)
    result = ResultHandler.new
    status_prop = request_body['status']
    user_id_prop = request_body['user_id']
    id_prop = request_body['id']

    if (is_blank(status_prop) || is_blank(user_id_prop) || is_blank(id_prop))
      result.set_error_data(:bad_request, I18n.t('messages.invalid_param'))
      return result
    end

    @notification = Notification.where(id: id_prop.to_i, user_id: user_id_prop.to_i).first
    if (@notification == nil)
      result.set_error_data(:not_found, I18n.t('messages.invalid_param'))
      return result
    end

    return result
  end

  def update_status_notifcation(request_body, notification)
    result = ResultHandler.new
    status_prop = request_body['status'].to_i
    user_id_prop = request_body['user_id'].to_i
    id_prop = request_body['id'].to_i

    notification.status = status_prop
    ActiveRecord::Base::transaction do
      if notification.save!
        result.set_success_data(:ok, notification)
      else
        result.set_error_data(:unprocessable_entity, notification.errors)
        raise ActiveRecord::Rollback
      end
    end

    result.set_success_data(:ok, notification)
    return result
  end

  def update_is_read(id_prop)
    result = ResultHandler.new
    query = get_query_notification_by_user(current_user.id, id_prop)
    data = Notification.select(query).where(id: id_prop.to_i).first
    if data.source_type == "messages"
      message_item = Message.where(id: data.source_id).first
      data.attachment_id = message_item.attachment_id
    else
      data.attachment_id = nil
    end
    data.is_read = 1
    data.updated_at = Time.now
    data.save!
    result.set_success_data(:ok, data)
    return result
  end

  def check_request_read(request_body, user_id)
    result = ResultHandler.new
    status_prop = request_body['is_read']
    id_prop = request_body['id']

    if (is_blank(status_prop)  || is_blank(id_prop))
      result.set_error_data(:bad_request, I18n.t('messages.invalid_param'))
      return result
    end

    @notification = Notification.where(id: id_prop.to_i, user_id: user_id.to_i).first
    if (@notification == nil)
      result.set_error_data(:not_found, I18n.t('messages.invalid_param'))
      return result
    end

    return result
  end

  def update_read_by_id(request_body)
    status_prop = request_body['is_read']
    id_prop = request_body['id'].to_i
    result = ResultHandler.new
    data = Notification.where(id: id_prop.to_i).first
    data.is_read = ActiveModel::Type::Boolean.new.cast(status_prop)
    data.updated_at = Time.now
    data.save!
    result.set_success_data(:ok, data)
    return result
  end
  
  def get_data_count_notification_has_read(_user_id)
    result = ResultHandler.new
    notiifcation_display_period = Setting.where('setting_key = ?', 'NOTIFICATION_DISPLAY_PERIOD').first!.setting_value
    date_now = Date.today - notiifcation_display_period.to_i.days
    user_id = _user_id.to_i
    count = Notification.where("user_id = ? AND is_read = 0 AND status = 1 AND created_at >= ?", user_id.to_i, date_now.beginning_of_day).count
    result.set_success_data(:ok, {total: count})
    return result
  end
   
  def send_notification_first_login
    user = User.find_by id: request["user_id"].to_i
    setting = Setting.where('setting_key = ?', 'TITLE_APP_NOTIFICATION').first()
    noti_title = "E-VG Caravelle"
    if setting != nil
      noti_title = setting.setting_value
    end
    if !user.nil?
      message = Message.first!
      user_first_login = UserFirstLogin.where('user_id = ?', user.id).first
      if user_first_login == nil
        notification = Notification.new
        notification.user_id = user.id.to_i
        notification.source_id = message != nil ? message.id : 1
        notification.source_type = "messages"
        notification.notification_type = 1
        notification.status = 1
        notification.status_type = 1
        notification.title = message != nil ? message.title : noti_title
        notification.title_ja = message != nil ? message.title_ja : noti_title
        notification.title_kr = message != nil ? message.title_kr : noti_title
        notification.title_cn = message != nil ? message.title_cn : noti_title
        notification.content = message != nil ? message.content : "Welcome to E-Vegas! The all-in-one App makes it easy to enjoy the best services you deserve."
        notification.content_ja = message != nil ? message.content_ja : "Welcome to E-Vegas! The all-in-one App makes it easy to enjoy the best services you deserve."
        notification.content_kr = message != nil ? message.content_kr : "Welcome to E-Vegas! The all-in-one App makes it easy to enjoy the best services you deserve."
        notification.content_cn = message != nil ? message.content_cn : "Welcome to E-Vegas! The all-in-one App makes it easy to enjoy the best services you deserve."
        notification.short_description = message != nil ? message.short_description : "Welcome to E-Vegas!"
        notification.short_description_ja = message != nil ? message.short_description_ja : "Welcome to E-Vegas!"
        notification.short_description_kr = message != nil ? message.short_description_kr : "Welcome to E-Vegas!"
        notification.short_description_cn = message != nil ? message.short_description_cn : "Welcome to E-Vegas!"
        if notification.save
          first_login = UserFirstLogin.new
          first_login.user_id = user.id.to_i
          first_login.save!
          if user.language == 'ja'
            send_notification_to_user(user.id, notification.title_ja, notification.source_type, notification.source_id, notification.id, message.attachment_id, notification.short_description_ja)
          elsif user.language == 'ko'
            send_notification_to_user(user.id, notification.title_kr, notification.source_type, notification.source_id, notification.id, message.attachment_id, notification.short_description_kr)
          elsif user.language == 'zh'
            send_notification_to_user(user.id, notification.title_cn, notification.source_type, notification.source_id, notification.id, message.attachment_id, notification.short_description_cn)
          else
            send_notification_to_user(user.id, notification.title, notification.source_type, notification.source_id, notification.id, message.attachment_id, notification.short_description)
          end
        end
        if user.sign_in_count == 0
          user.sign_in_count = 1
          user.save!
        end
      end
    end
  end

  def syns_notification
    time_now = Time.zone.now
    message = Message.where('time_send < ? AND is_draft = 0 AND is_send = 0', time_now).first
    if message != nil
      send_notification_job(message)
    end
  end

  def send_notification_job(message)
    where_query = ""
    user_customers = []
    user_customers_not_send = []
    is_send_all = 0
    if message.user_ids.to_i == 0
      where_query = "devices.id > 0"
      user_customers = User.select('users.id, users.language, customers.title, customers.forename, customers.number').joins(:customer => [], :devices => []).where("devices.id > 0").order('devices.id desc').uniq
    else
      is_send_all = 0
      user_ids = message.user_ids.split(',').map(&:to_i)
      user_customers = User.select('users.id, users.language, customers.title, customers.forename, customers.middle_name, customers.surname, customers.number')
      .joins(:customer => [], :devices => []).where(users: { id: user_ids }).order('devices.id desc').uniq
    end
    
    message.is_send = 1
    customerList = []
    lst_notifi_not_send = []
    list_not_noti = []

    if message.customer_attachment.to_i != 0
      require 'open-uri'
      url = HOST_NAME.to_s + PATH_API_ATTACHMENT.to_s + message.customer_attachment.to_s
      file = URI.open(url)
      spreadsheet = Roo::Spreadsheet.open(file, extension: :xlsx, convert: false)

      header = spreadsheet.sheet(0).row(1)
      amount_2_exists = header.include?('amount2')
      (2..spreadsheet.sheet(0).last_row).map do |i|
        row = Hash[[header, spreadsheet.sheet(0).row(i)].transpose]
        if amount_2_exists
          customerList.push(FileCustomerImport.new(row["number"], row["title"], row["name"], row["amount"], row["amount2"], row["date_month_year"], row["time"], row["host_phone"]))
        else
          customerList.push(FileCustomerImport.new(row["number"], row["title"], row["name"], row["amount"], nil, row["date_month_year"], row["time"], row["host_phone"]))
        end
      end
      file.close
    end

    if message.save!
      user_customers.each do |user|
        name_cfg = ""
        title_cfg = ""
        amount_cfg = ""
        amount_cfg_2 = ""
        date_month_year_cfg = ""
        time_cfg = ""
        host_phone_cfg = ""
        customerList.each do |excel_cfg|
          if excel_cfg.number_cfg.to_s == user.number.to_s
            name_cfg = excel_cfg.name_cfg.to_s
            title_cfg = excel_cfg.title_cfg.to_s
            amount_cfg = excel_cfg.amount_cfg.to_s
            amount_cfg_2 = excel_cfg.amount_cfg_2.to_s
            date_month_year_cfg = excel_cfg.date_month_year_cfg.to_s
            time_cfg = excel_cfg.time_cfg.to_s
            host_phone_cfg = excel_cfg.host_phone_cfg.to_s
          end
        end

        notification = Notification.new
        notification.user_id = user.id
        notification.source_id = message.id
        notification.source_type = "messages"
        notification.notification_type = message.category
        notification.title = message.title
        notification.status = 1
        notification.status_type = 1
        notification.title_ja = message.title_ja
        notification.title_kr = message.title_kr
        notification.title_cn = message.title_cn
        notification.content = replace_title_and_name_customer(message.content, title_cfg, name_cfg, amount_cfg, amount_cfg_2, date_month_year_cfg, time_cfg, host_phone_cfg)
        notification.content_ja = replace_title_and_name_customer(message.content_ja, title_cfg, name_cfg, amount_cfg, amount_cfg_2, date_month_year_cfg, time_cfg, host_phone_cfg)
        notification.content_kr = replace_title_and_name_customer(message.content_kr, title_cfg, name_cfg, amount_cfg, amount_cfg_2, date_month_year_cfg, time_cfg, host_phone_cfg)
        notification.content_cn = replace_title_and_name_customer(message.content_cn, title_cfg, name_cfg, amount_cfg, amount_cfg_2, date_month_year_cfg, time_cfg, host_phone_cfg)
        notification.short_description = message.short_description
        notification.short_description_ja = message.short_description_ja
        notification.short_description_kr = message.short_description_kr
        notification.short_description_cn = message.short_description_cn
        notification.category = message.category
        notification.created_at = message.time_send
        notification.updated_at = message.time_send
        if notification.save!
          if user.language == 'ja'
            if notification.title_ja.present? && notification.short_description_ja.present? && notification.content_ja.present?
              send_notification_to_user(user.id, message.title_ja, "messages", notification.source_id, notification.id, message.attachment_id, message.short_description_ja)
            else
              send_notification_to_user(user.id, message.title, "messages", notification.source_id, notification.id, message.attachment_id, message.short_description)  
            end
          elsif user.language == 'ko'
            if notification.title_kr.present? && notification.short_description_kr.present? && notification.content_kr.present?
              send_notification_to_user(user.id, message.title_kr, "messages", notification.source_id, notification.id, message.attachment_id, message.short_description_kr)  
            else
              send_notification_to_user(user.id, message.title, "messages", notification.source_id, notification.id, message.attachment_id, message.short_description)  
            end
          elsif user.language == 'zh'
            if notification.title_cn.present? && notification.short_description_cn.present? && notification.content_cn.present?
              send_notification_to_user(user.id, message.title_cn, "messages", notification.source_id, notification.id, message.attachment_id, message.short_description_cn)
            else
              send_notification_to_user(user.id, message.title, "messages", notification.source_id, notification.id, message.attachment_id, message.short_description)  
            end
          else
            send_notification_to_user(user.id, message.title, "messages", notification.source_id, notification.id, message.attachment_id, message.short_description)
          end
        end

        list_not_noti.push(user.id)
      end
    end
    
    if list_not_noti.length > 0 && is_send_all == 0
      list_not_noti = user_ids - list_not_noti
      if list_not_noti.length > 0
        user_customers_not_send = User.select('users.id, users.language, customers.title, customers.forename, customers.middle_name, customers.surname, customers.number')
        .joins(:customer => []).where(users: { id: list_not_noti }).order('users.id desc').uniq
      end
    end

    if user_customers_not_send.length > 0
      user_customers_not_send.each do |user|
        name_cfg = ""
        title_cfg = ""
        amount_cfg = ""
        amount_cfg_2 = ""
        date_month_year_cfg = ""
        time_cfg = ""
        host_phone_cfg = ""
        customerList.each do |excel_cfg|
          if excel_cfg.number_cfg.to_s == user.number.to_s
            name_cfg = excel_cfg.name_cfg.to_s
            title_cfg = excel_cfg.title_cfg.to_s
            amount_cfg = excel_cfg.amount_cfg.to_s
            amount_cfg_2 = excel_cfg.amount_cfg_2.to_s
            date_month_year_cfg = excel_cfg.date_month_year_cfg.to_s
            time_cfg = excel_cfg.time_cfg.to_s
            host_phone_cfg = excel_cfg.host_phone_cfg.to_s
          end
        end

        notification = Notification.new
        notification.user_id = user.id
        notification.source_id = message.id
        notification.source_type = "messages"
        notification.notification_type = message.category
        notification.title = message.title
        notification.status = 1
        notification.status_type = -1
        notification.title_ja = message.title_ja
        notification.title_kr = message.title_kr
        notification.title_cn = message.title_cn
        notification.content = replace_title_and_name_customer(message.content, title_cfg, name_cfg, amount_cfg, amount_cfg_2, date_month_year_cfg, time_cfg, host_phone_cfg)
        notification.content_ja = replace_title_and_name_customer(message.content_ja, title_cfg, name_cfg, amount_cfg, amount_cfg_2, date_month_year_cfg, time_cfg, host_phone_cfg)
        notification.content_kr = replace_title_and_name_customer(message.content_kr, title_cfg, name_cfg, amount_cfg, amount_cfg_2, date_month_year_cfg, time_cfg, host_phone_cfg)
        notification.content_cn = replace_title_and_name_customer(message.content_cn, title_cfg, name_cfg, amount_cfg, amount_cfg_2, date_month_year_cfg, time_cfg, host_phone_cfg)
        notification.short_description = message.short_description
        notification.short_description_ja = message.short_description_ja
        notification.short_description_kr = message.short_description_kr
        notification.short_description_cn = message.short_description_cn
        notification.category = message.category
        notification.created_at = message.time_send
        notification.updated_at = message.time_send
        notification.save!
      end
    end

  end

  def replace_title_and_name_customer(content, title_cfg, name_cfg, amount_cfg, amount_cfg_2, date_month_year_cfg, time_cfg, host_phone_cfg)
    if content.include? "#title"
      content = content.gsub('#title', title_cfg.to_s)
    end
    if content.include? "#name"
      content = content.gsub('#name', name_cfg.to_s)
    end
    if content.include? "#amount2"
      content = content.gsub('#amount2', number_to_currency(amount_cfg_2, precision: 0, delimiter: ',', format: '%n'))
    end
    if content.include? "#amount"
      content = content.gsub('#amount', number_to_currency(amount_cfg, precision: 0, delimiter: ',', format: '%n'))
    end
    if content.include? "#date_month_year"
      content = content.gsub('#date_month_year', date_month_year_cfg.to_s)
    end
    if content.include? "#time"
      content = content.gsub('#time', time_cfg.to_s)
    end
    if content.include? "#host_phone"
      content = content.gsub('#host_phone', "<a href='tel:" + host_phone_cfg.to_s.gsub(/[\(\),-]/, '') + "'>"+host_phone_cfg.to_s+"</a>")
    end
    return content
  end

  def syns_offer_subscriber_notification
    time_now = Time.zone.now
    noti_subcriber = OfferSubscriber.where('time_send < ? AND is_send = 0 AND time_send IS NOT NULL', time_now).first
    if noti_subcriber != nil
      # send_offer_subscriber_job(noti_subcriber)
    end
  end

  def send_offer_subscriber_job(offer_sub)
    user_customers = User.select('users.id, users.language').joins(:customer => [], :devices => []).where('users.id = ?', offer_sub.user_id).order('devices.id desc').uniq
    setting = Setting.where('setting_key = ?', 'TITLE_APP_NOTIFICATION').first()
    noti_title = "E-VG Caravelle"
    if setting != nil
      noti_title = setting.setting_value
    end
    offer_sub.is_send = 1
    offer_sub.save
    user_customers.each do |user|
      message = Offer.find(offer_sub.offer_id)
      notification = Notification.new
      notification.user_id = user.id
      notification.source_id = message.id
      notification.source_type = message.offer_type == 1 ? "Offers" : "Event"
      notification.notification_type = message.offer_type == 1 ? 9 : 10
      notification.status = 1
      notification.status_type = 1
      notification.title = noti_title
      notification.title_ja = noti_title
      notification.title_kr = noti_title
      notification.title_cn = noti_title
      notification.content = message.description
      notification.content_ja = message.description_ja
      notification.content_kr = message.description_kr
      notification.content_cn = message.description_cn
      notification.short_description = message.title
      notification.short_description_ja = message.title_ja
      notification.short_description_kr = message.title_kr
      notification.short_description_cn = message.title_cn
      notification.category = message.offer_type == 1 ? 9 : 10

      if notification.save!
        if user.language == 'ja'
          send_notification_to_user(user.id, message.title_ja, notification.source_type, notification.source_id, notification.id, message.attachment_id, notification.short_description_ja)
        elsif user.language == 'ko'
          send_notification_to_user(user.id, message.title_kr, notification.source_type, notification.source_id, notification.id, message.attachment_id, notification.short_description_kr)
        elsif user.language == 'zh'
          send_notification_to_user(user.id, message.title_cn, notification.source_type, notification.source_id, notification.id, message.attachment_id, notification.short_description_cn)
        else
          send_notification_to_user(user.id, message.title, notification.source_type, notification.source_id, notification.id, message.attachment_id, notification.short_description)
        end
      end
    end
  end

  def send_notification_spa(spa)
    notification_old = Notification.where('source_id = ? AND notification_type = 7 AND status_type = ?', spa.id, spa.status).first
    if notification_old != nil
      return
    end
    user = User.select('users.id, users.language').joins(:customer).where('customers.id = ?', spa.customer_id.to_i).first
    setting_message = JSON.parse(Setting.where('setting_key = ?', 'SPA_STATUS_CONFIG').first().setting_value)
    if user != nil
      notification = Notification.new
      notification.user_id = user.id.to_i
      notification.source_id = spa.id
      notification.source_type = "spas"
      notification.notification_type = 7
      notification.status_type = spa.status
      notification.status = 1
      setting_message['status'].each do |item|
        if spa.status == item['id'].to_i
          notification.title = item['title']
          notification.title_ja = item['title_ja']
          notification.title_kr = item['title_ko']
          notification.title_cn = item['title_zh']
          notification.content = item['message']
          notification.content_ja = item['message_ja']
          notification.content_kr = item['message_ko']
          notification.content_cn = item['message_zh']
          notification.short_description = item['description']
          notification.short_description_ja = item['description_ja']
          notification.short_description_kr = item['description_ko']
          notification.short_description_cn = item['description_zh']
          break
        end
      end

      if notification.save
        if user.language == 'ja'
          send_notification_to_user(user.id, notification.title_ja, notification.source_type, notification.source_id, notification.id, nil, notification.short_description_ja)
        elsif user.language == 'ko'
          send_notification_to_user(user.id, notification.title_kr, notification.source_type, notification.source_id, notification.id, nil, notification.short_description_kr)
        elsif user.language == 'zh'
          send_notification_to_user(user.id, notification.title_cn, notification.source_type, notification.source_id, notification.id, nil, notification.short_description_cn)
        else
          send_notification_to_user(user.id, notification.title, notification.source_type, notification.source_id, notification.id, nil, notification.short_description)
        end
      end
    end
  end

  def send_notification_accomandation(accommodation)
    notification_old = Notification.where('source_id = ? AND notification_type = 8 AND status_type = ?', accommodation.id, accommodation.status).first
    if notification_old != nil
      return
    end
    user = User.select('users.id, users.language').joins(:customer).where('customers.id = ?', accommodation.customer_id.to_i).first
    setting_message = JSON.parse(Setting.where('setting_key = ?', 'ACCOMMODATION_STATUS_CONFIG').first().setting_value)
    if user != nil
      notification = Notification.new
      notification.user_id = user.id
      notification.source_id = accommodation.id
      notification.source_type = "accommodations"
      notification.notification_type = 8
      notification.status_type = accommodation.status
      notification.status = 1
      setting_message['status'].each do |item|
        if accommodation.status == item['id'].to_i
          notification.title = item['title']
          notification.title_ja = item['title_ja']
          notification.title_kr = item['title_ko']
          notification.title_cn = item['title_zh']
          notification.content = item['message']
          notification.content_ja = item['message_ja']
          notification.content_kr = item['message_ko']
          notification.content_cn = item['message_zh']
          notification.short_description = item['description']
          notification.short_description_ja = item['description_ja']
          notification.short_description_kr = item['description_ko']
          notification.short_description_cn = item['description_zh']
          break
        end
      end
      if notification.save
        if user.language == 'ja'
          send_notification_to_user(user.id, notification.title_ja, notification.source_type, notification.source_id, notification.id, nil, notification.short_description_ja)
        elsif user.language == 'ko'
          send_notification_to_user(user.id, notification.title_kr, notification.source_type, notification.source_id, notification.id, nil, notification.short_description_kr)
        elsif user.language == 'zh'
          send_notification_to_user(user.id, notification.title_cn, notification.source_type, notification.source_id, notification.id, nil, notification.short_description_cn)
        else
          send_notification_to_user(user.id, notification.title, notification.source_type, notification.source_id, notification.id, nil, notification.short_description)
        end
      end
    end
  end

  def send_notification_booking_car(booking)
    notification_old = Notification.where('source_id = ? AND notification_type = 2 AND status_type = ?', booking.id, booking.status).first
    if notification_old != nil
      return
    end
    user = User.select('users.id, users.language').joins(:customer).where('customers.id = ?', booking.customer_id.to_i).first
    setting_message = JSON.parse(Setting.where('setting_key = ?', 'BOOKING_CONFIG').first().setting_value)
    drop_time = booking.drop_off_at.present? ? booking.drop_off_at.strftime("%H:%M %d-%m-%Y") : ""
    if user != nil
      notification = Notification.new
      notification.user_id = user.id.to_i
      notification.source_id = booking.id
      notification.source_type = "reservations"
      notification.notification_type = 2
      notification.status_type = booking.status
      notification.status = 1
      setting_message['status'].each do |item|
        if booking.status.to_i == item['id'].to_i
          notification.title = item['title']
          notification.title_ja = item['title_ja']
          notification.title_kr = item['title_ko']
          notification.title_cn = item['title_zh']
          notification.content = (item['message'].include? "#drop_off_time") == true ? item['message'].gsub('#drop_off_time', drop_time.to_s).to_s : item['message']
          notification.content_ja = (item['message_ja'].include? "#drop_off_time") == true ? item['message_ja'].gsub('#drop_off_time', drop_time.to_s).to_s : item['message_ja']
          notification.content_kr = (item['message_ko'].include? "#drop_off_time") == true ? item['message_ko'].gsub('#drop_off_time', drop_time.to_s).to_s : item['message_ko']
          notification.content_cn = (item['message_zh'].include? "#drop_off_time") == true ? item['message_zh'].gsub('#drop_off_time', drop_time.to_s).to_s : item['message_zh']
          notification.short_description = item['description']
          notification.short_description_ja = item['description_ja']
          notification.short_description_kr = item['description_ko']
          notification.short_description_cn = item['description_zh']
          break
        end
      end

      if notification.save
        if user.language == 'ja'
          send_notification_to_user(user.id, notification.title_ja, notification.source_type, notification.source_id, notification.id, nil, notification.short_description_ja)
        elsif user.language == 'ko'
          send_notification_to_user(user.id, notification.title_kr, notification.source_type, notification.source_id, notification.id, nil, notification.short_description_kr)
        elsif user.language == 'zh'
          send_notification_to_user(user.id, notification.title_cn, notification.source_type, notification.source_id, notification.id, nil, notification.short_description_cn)
        else
          send_notification_to_user(user.id, notification.title, notification.source_type, notification.source_id, notification.id, nil, notification.short_description)
        end
      end
    end
  end

  def send_notification_machine_reservation(machine_reservation)
    notification_old = Notification.where('source_id = ? AND notification_type = 3 AND status_type = ?', machine_reservation.id, machine_reservation.status).first
    if notification_old != nil
      return
    end
    user = User.select('users.id, users.language').joins(:customer).where('customers.id = ?', machine_reservation.customer_id.to_i).first
    setting_message = JSON.parse(Setting.where('setting_key = ?', 'MACHINE_BOOKING_CONFIG').first().setting_value)
    # setting = Setting.where('setting_key = ?', 'TITLE_APP_NOTIFICATION').first()
    if user != nil
      notification = Notification.new
      notification.user_id = user.id.to_i
      notification.source_id = machine_reservation.id
      notification.source_type = "machine_reservations"
      notification.notification_type = 3
      notification.status_type = machine_reservation.status
      notification.status = 1
      setting_message['status'].each do |item|
        if machine_reservation.status == item['id'].to_i
          notification.title = item['title']
          notification.title_ja = item['title_ja']
          notification.title_kr = item['title_ko']
          notification.title_cn = item['title_zh']
          notification.content = (item['message'].include? "#machine_number") == true ? item['message'].gsub('#machine_number', "#" + machine_reservation.machine_number.to_s) : item['message']
          notification.content_ja = (item['message_ja'].include? "#machine_number") == true ? item['message_ja'].gsub('#machine_number', "#" + machine_reservation.machine_number.to_s) : item['message_ja']
          notification.content_kr = (item['message_ko'].include? "#machine_number") == true ? item['message_ko'].gsub('#machine_number', "#" + machine_reservation.machine_number.to_s) : item['message_ko']
          notification.content_cn = (item['message_zh'].include? "#machine_number") == true ? item['message_zh'].gsub('#machine_number', "#" + machine_reservation.machine_number.to_s) : item['message_zh']
          notification.short_description = (item['description'].include? "#machine_number") == true ? item['description'].gsub('#machine_number', "#" + machine_reservation.machine_number.to_s) : item['description']
          notification.short_description_ja = (item['description_ja'].include? "#machine_number") == true ? item['description_ja'].gsub('#machine_number', "#" + machine_reservation.machine_number.to_s) : item['description_ja']
          notification.short_description_kr = (item['description_ko'].include? "#machine_number") == true ? item['description_ko'].gsub('#machine_number', "#" + machine_reservation.machine_number.to_s) : item['description_ko']
          notification.short_description_cn = (item['description_zh'].include? "#machine_number") == true ? item['description_zh'].gsub('#machine_number', "#" + machine_reservation.machine_number.to_s) : item['description_zh']
          break
        end
      end
      if notification.save
        if user.language == 'ja'
          send_notification_to_user(user.id, notification.title_ja, notification.source_type, notification.source_id, notification.id, nil, notification.short_description_ja)
        elsif user.language == 'ko'
          send_notification_to_user(user.id, notification.title_kr, notification.source_type, notification.source_id, notification.id, nil, notification.short_description_kr)
        elsif user.language == 'zh'
          send_notification_to_user(user.id, notification.title_cn, notification.source_type, notification.source_id, notification.id, nil, notification.short_description_cn)
        else
          send_notification_to_user(user.id, notification.title, notification.source_type, notification.source_id, notification.id, nil, notification.short_description)
        end
      end
    end
  end

  # def update_delete_notification
  #   notification_deleted = Notification.where('created_at < NOW() - INTERVAL 30 DAY AND is_delete = 0')
  #   if notification_deleted.length > 0
  #     notification_deleted = notification_deleted.update_all(is_delete: 1)
  #   end
  # end

end
