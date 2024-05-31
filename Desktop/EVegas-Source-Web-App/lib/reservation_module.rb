module ReservationModule
  include CommonModule
  include DaoModule

  include NotificationModule

  RESERVATION_ATTRIBUTE = ClassAttribute.new
  RESERVATION_ATTRIBUTE.clazz = Reservation
  RESERVATION_ATTRIBUTE.object_key = "reservation"
  RESERVATION_ATTRIBUTE.filter_params = ["search", "by_customer", "by_status"]
  RESERVATION_ATTRIBUTE.create_params = ["customer_id", "address", "pickup_at", "customer_note", "current_location", "status"]
  RESERVATION_ATTRIBUTE.index_except_params = ["price"]
  RESERVATION_ATTRIBUTE.show_except_params = ["price"]
  RESERVATION_ATTRIBUTE.include_object_params = {
    "customer" => ["id", "forename", "middle_name", "surname"]
  }

  def check_params_create_or_update(_request_body, _id = nil)
    result = ResultHandler.new
    time_now = Time.zone.now
    date_pick = Time.zone.parse(_request_body["pickup_at"])
    if date_pick < time_now
      result.set_error_data(:bad_request, "The booking date and time must be in the future. Please select date and time again.")
      return result
    end

    customer_id = _request_body['customer_id'].to_i
    user = User.select('users.language, membership_type_name').joins(:customer).where('customers.id = ?', customer_id).first
    data = Reservation.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, customer_id: customer_id, status: 1).order('created_at desc').first()
    if data != nil
      time_pick = (Time.zone.now.to_time.to_i - data['created_at'].to_time.to_i)/60
      setting = Setting.where('setting_key = ?', 'TIME_BOOK_CAR').first()
      if setting
        if setting['setting_value'].to_i > time_pick
          if user.language == 'ja'
              result.set_error_data(:bad_request, I18n.t('booking_reject_ja'))
          elsif user.language == 'ko'
              result.set_error_data(:bad_request, I18n.t('booking_reject_ko'))
          elsif user.language == 'zh'
              result.set_error_data(:bad_request, I18n.t('booking_reject_zh'))
          else
              result.set_error_data(:bad_request, I18n.t('booking_reject'))
          end
          return result
        end
        return result
      else
        result.set_error_data(:bad_request, I18n.t('time_booking_required'))
        return result
      end
    end

    settings = Setting.where('setting_key = ?', 'BOOKING_REJECT_LEVEL_CONFIG').first().setting_value
    level_reject = JSON.parse(settings)
    level_reject['Level'].each do |item|
      if user.membership_type_name.strip.upcase == item['name'].strip.upcase
        if user.language == 'ja'
            result.set_error_data(:bad_request, I18n.t('booking_reject_level_ja'))
        elsif user.language == 'ko'
            result.set_error_data(:bad_request, I18n.t('booking_reject_level_ko'))
        elsif user.language == 'zh'
            result.set_error_data(:bad_request, I18n.t('booking_reject_level_zh'))
        else
            result.set_error_data(:bad_request, I18n.t('booking_reject_level'))
        end
        return result
      end
    end

    config_levels = Setting.where('setting_key = ?', 'BOOKING_LIMIT_BY_LEVEL_CONFIG').first().setting_value
    config_level_objects = JSON.parse(config_levels)
    config_level_objects.each do |item|
      if user[:membership_type_name].strip.upcase == item['name'].strip.upcase
        day_limit = item['number_day'].to_i
        num_limit = item['limit'].to_i
        day_book = DateTime.now - day_limit.to_i
        number_data = Reservation.where('created_at >= ? AND customer_id = ?', day_book, customer_id).length

        if number_data > num_limit
          if user.language == 'ja'
              result.set_error_data(:bad_request, I18n.t('booking_reject_level_ja'))
          elsif user.language == 'ko'
              result.set_error_data(:bad_request, I18n.t('booking_reject_level_ko'))
          elsif user.language == 'zh'
              result.set_error_data(:bad_request, I18n.t('booking_reject_level_zh'))
          else
              result.set_error_data(:bad_request, I18n.t('booking_reject_level'))
          end
          return result
        end
      end
    end

    return result
  end

  # Create new object and save it into database
  def create_object(clazz, object_key, create_params)
    result = ResultHandler.new
    object = clazz.new(get_data_object_request_body(object_key, create_params))
    # object = initialize_new_object(object)
    logger.debug "New object: #{object.attributes.inspect}"
    logger.debug "Object should be valid: #{object.valid?}"
    ActiveRecord::Base::transaction do
      if object.save
        result.set_success_data(:created, object)
        # TODO: Send notification to user
        # 
        thread = Thread.new do
          begin
            sleep(1)
            send_notification_booking_car(object)
            if object.status == 1
              user_cus = Customer.where('id = ?', object.customer_id.to_i).first
              message = "Customer " + user_cus.forename.to_s + " number #" + user_cus.number.to_s + " book car"
              send_notification_to_user_web("New car booking", message, "reservations", object.id)
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

end