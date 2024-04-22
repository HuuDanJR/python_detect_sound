module MachineReservationModule
  include CommonModule
  include DaoModule
  include NotificationModule

  MACHINE_RESERVATION_ATTRIBUTE = ClassAttribute.new
  MACHINE_RESERVATION_ATTRIBUTE.clazz = MachineReservation
  MACHINE_RESERVATION_ATTRIBUTE.object_key = "machine_reservation"
  MACHINE_RESERVATION_ATTRIBUTE.filter_params = ["search", "by_customer", "by_ended_at_from", "by_ended_at_to", "by_started_at_from", "by_started_at_to", "by_status"]
  MACHINE_RESERVATION_ATTRIBUTE.create_params = ["customer_id", "machine_number", "machine_name", "started_at", "ended_at", "booking_type", "customer_note", "status"]
  MACHINE_RESERVATION_ATTRIBUTE.update_params = ["started_at", "ended_at", "status", "customer_id", "customer_note"]
  MACHINE_RESERVATION_ATTRIBUTE.index_except_params = []
  MACHINE_RESERVATION_ATTRIBUTE.show_except_params = []
  MACHINE_RESERVATION_ATTRIBUTE.include_object_params = {
    "customer" => ["id", "forename", "middle_name", "surname"],
    "gametheme" => ["id", "game_type_id", "name", "attachment_id"]
  }
  
  def check_params_create_or_update(_request_body, _id = nil)
    result = ResultHandler.new
    customer_id = _request_body['customer_id'].to_i
    user = User.select('users.language, membership_type_name').joins(:customer).where('customers.id = ?', customer_id).first
    data = MachineReservation.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, customer_id: customer_id, status: 1).order('created_at desc').first()
    if data != nil
      time_pick = (Time.zone.now.to_time.to_i - data['created_at'].to_time.to_i)/60
      setting = Setting.where('setting_key = ?', 'TIME_MC_RESERVATION').first()
      if setting
        if setting['setting_value'].to_i > time_pick
          if user.language == 'ja'
              result.set_error_data(:bad_request, I18n.t('booking_mc_reservation_reject_ja'))
          elsif user.language == 'ko'
              result.set_error_data(:bad_request, I18n.t('booking_mc_reservation_reject_ko'))
          elsif user.language == 'zh'
              result.set_error_data(:bad_request, I18n.t('booking_mc_reservation_reject_zh'))
          else
              result.set_error_data(:bad_request, I18n.t('booking_mc_reservation_reject'))
          end
          return result
        end
        return result
      else
        result.set_error_data(:bad_request, I18n.t('time_booking_required'))
        return result
      end
    end

    settings = Setting.where('setting_key = ?', 'BOOKING_REJECT_MC_RESERVATION_LEVEL_CONFIG').first().setting_value
    level_reject = JSON.parse(settings)
    level_reject['Level'].each do |item|
      if user.membership_type_name.strip.upcase == item['name'].strip.upcase
        if user.language == 'ja'
            result.set_error_data(:bad_request, I18n.t('booking_reject_mc_reservation_level_ja'))
        elsif user.language == 'ko'
            result.set_error_data(:bad_request, I18n.t('booking_reject_mc_reservation_level_ko'))
        elsif user.language == 'zh'
            result.set_error_data(:bad_request, I18n.t('booking_reject_mc_reservation_level_zh'))
        else
            result.set_error_data(:bad_request, I18n.t('booking_reject_mc_reservation_level'))
        end
        return result
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
            send_notification_machine_reservation(object)
            if object.status == 1
              user_cus = Customer.where('id = ?', object.customer_id.to_i).first
              message = "Customer " + user_cus.forename.to_s + " number #" + user_cus.number.to_s + " MC reservation"
              send_notification_to_user_web("New MC reservation", message, "machine_reservations", object.id)
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

  def get_data_machine_number_from_neon(_number)
    result = ResultHandler.new
    machine = {
      number: -1,
      name: "",
      machine_game_theme_id: -1
    }
    vegas_internal_api = Setting.where('setting_key = ?', 'VC_INTERNAL_API').first!.setting_value

    req_body = {
      number: _number.to_s
    }
    res_data = get_content_from_url(vegas_internal_api + "/api/find_gametheme_by_number", :post, req_body)

    if res_data.result
      if !res_data.data.nil? && res_data.data != ""
        res_data_json = JSON.parse(res_data.data)
        machine[:number] = res_data_json["Number"].to_i
        machine[:name] = res_data_json["Name"]
        machine[:machine_game_theme_id] = res_data_json["MachineGameThemeID"]
        result.set_success_data(:ok, machine)
        return result
      end
    end

    result.set_success_data(:bad_request, machine)
    
    return result
  end

  def get_data_machine_from_neon()
    machines = []
    vegas_internal_api = Setting.where('setting_key = ?', 'VC_INTERNAL_API').first!.setting_value
    res_data = get_content_from_url(vegas_internal_api + "/api/all_gametheme", :get)

    if res_data.result
      if !res_data.data.nil? && res_data.data != ""
        record_data = JSON.parse(res_data.data)["recordset"]
        if !record_data.nil? && record_data.length > 0
          record_data.each do |item|
            machine = {
              number: item["Number"].to_s,
              name: item["Name"].to_s,
              machine_game_theme_id: item["MachineGameThemeID"].to_s,
              disabled: false,
              number_name: item["Number"].to_s + " - " + item["Name"].to_s,
              game_type_id: item["GameTypeID"].to_i
            }
            machines.push(machine)
          end
        end
      end
    end
    return machines
  end

  def list_machine_has_used(started_at, ended_at)
    list_machine = MachineReservation.where('started_at >= ? OR ended_at >= ? AND status > 0', started_at, ended_at)
    return list_machine
  end

end