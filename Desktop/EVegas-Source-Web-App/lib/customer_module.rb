module CustomerModule
  include CommonModule
  include DaoModule
  include AttachmentModule

  CUSTOMER_ATTRIBUTE = ClassAttribute.new
  CUSTOMER_ATTRIBUTE.clazz = Customer
  CUSTOMER_ATTRIBUTE.object_key = "customer"
  CUSTOMER_ATTRIBUTE.filter_params = ["search"]
  CUSTOMER_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  CUSTOMER_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  CUSTOMER_ATTRIBUTE.include_object_params = {}

  def validate_get_customer_by_user_id(_user_id)
    result = ResultHandler.new
    user_id = _user_id.to_i
    
    if (is_blank(user_id))
      result.set_error_data(:bad_request, I18n.t('messages.object_to_required'))
      return result
    end

    return result
  end

  def get_data_customer_by_user_id(_user_id)
    result = ResultHandler.new
    user_id = _user_id.to_i
    data =  User.select('customers.*, users.language, users.setting').joins(:customer).where('customers.user_id = ?', user_id).first

    result.set_success_data(:ok, data)
    return result
  end

  def get_customers_from_neon()
    # create a client for the service
    neon_api = Setting.where('setting_key = ?', 'NEON_API').first!.setting_value
    computer_name = Setting.where('setting_key = ?', 'NEON_COMPUTER_NAME').first!.setting_value
    client = Savon.client(wsdl: neon_api + '?wsdl', endpoint: neon_api)
    
    # puts client.operations
    xml = '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
        <Body>
            <FindCustomers xmlns="http://www.IntelligentGaming.co.uk">
                <!-- Optional -->
                <request>
                    <ComputerName xmlns="IG.Cms.Gateway.DataContracts">#{ComputerName}</ComputerName>
                    <AgeFrom xmlns="IG.Cms.Gateway.DataContracts">18</AgeFrom>
                    <AgeTo xmlns="IG.Cms.Gateway.DataContracts">50</AgeTo>
                    <Forename xmlns="IG.Cms.Gateway.DataContracts"></Forename>
                    <Surname xmlns="IG.Cms.Gateway.DataContracts"></Surname>
                </request>
            </FindCustomers>
        </Body>
    </Envelope>'
    xml = xml.gsub('#{ComputerName}', computer_name)
    
    # call the 'FindCustomers' operation
    response = client.call(:find_customers, xml: xml)
    data = response.body
    
    return data[:find_customers_response][:find_customers_result][:customers][:customer_data]
  end

  def get_customer_by_card(card_number, _neon_api = nil, _computer_name = nil)
    # create a client for the service
    neon_api =  _neon_api != nil ? _neon_api : Setting.where('setting_key = ?', 'NEON_LOYALTY_API').first!.setting_value
    computer_name = _computer_name != nil ? _computer_name : Setting.where('setting_key = ?', 'NEON_COMPUTER_NAME').first!.setting_value
    client = Savon.client(wsdl: neon_api + '?wsdl', endpoint: neon_api)
    
    # puts client.operations
    xml = '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
            <Body>
                <GetCustomerByCard xmlns="http://www.IntelligentGaming.co.uk">
                    <!-- Optional -->
                    <request>
                        <ComputerName xmlns="IG.Cms.Gateway.DataContracts">#{ComputerName}</ComputerName>
                        <CardTrackData xmlns="IG.Cms.Gateway.DataContracts">#{CardNumber}</CardTrackData>
                        <SuppressVisit xmlns="IG.Cms.Gateway.DataContracts">true</SuppressVisit>
                    </request>
                </GetCustomerByCard>
            </Body>
          </Envelope>'
    xml = xml.gsub('#{ComputerName}', computer_name).gsub('#{CardNumber}', card_number.to_s)
    
    # call the 'GetCustomerByCard' operation
    response = client.call(:get_customer_by_card, xml: xml)
    
    data = response.body
    return data[:get_customer_by_card_response][:get_customer_by_card_result][:customer]
  end

  def get_pin_code_customer_default(date_of_birth)
    return date_of_birth.strftime("%m%y")
  end

  def get_data_customer_point(id)
    result = ResultHandler.new

    customer = Customer.find(id)
    vegas_internal_api = Setting.where('setting_key = ?', 'VC_INTERNAL_API').first!.setting_value
    start_date = Date.today
    end_date = start_date + 1.days
    current_friday, next_friday = find_current_and_next_fridays(start_date)

    req_body = {
      id: customer.number,
      dateToday: start_date.strftime('%Y-%m-%d'),
      dateToday2: end_date.strftime('%Y-%m-%d'),
      startDateWeek: current_friday.strftime('%Y-%m-%d'),
      endDateWeek: next_friday.strftime('%Y-%m-%d'),
      startDateMonth: start_date.at_beginning_of_month.strftime('%Y-%m-%d'),
      endDateMonth:start_date.at_end_of_month.strftime('%Y-%m-%d')
    }
    res_data = get_content_from_url(vegas_internal_api + "/api/point_by_date_cardtrack2", :post, req_body)

    req_body2 = {
      id: customer.number
    }
    res_data2 = get_content_from_url(vegas_internal_api + "/api/point_user", :post, req_body2)
    out_of_range_date = false
    out_of_date = (Date.today-1).end_of_day

    if customer.frame_start_date != nil && customer.frame_end_date != nil
      req_body3 = {
        number: customer.number,
        startDate: customer.frame_start_date.strftime('%Y-%m-%d'),
        endDate: customer.frame_end_date.strftime('%Y-%m-%d')
      }
      if customer.frame_end_date <= out_of_date
        out_of_range_date = true
      end
      res_data3 = get_content_from_url(vegas_internal_api + "/api/point_by_date_number/range", :post, req_body3)
    end

    point_data = {
      loyalty_point: 0,
      loyalty_point_next_1: 0,
      loyalty_point_sub_next_1: '',
      loyalty_point_next_2: 0,
      loyalty_point_sub_next_2: '',
      loyalty_point_weekly: 0,
      loyalty_point_weekly_range: '',
      loyalty_point_weekly_next_draw: 0,
      wallet: 0,
      fortune_credit: 0,
      credit_point: 0,
      loyalty_point_today: 0,
      loyalty_point_current: 0,
      loyalty_point_month: 0,
      loyalty_point_today_slot: 0,
      loyalty_point_today_rltb: 0,
      frame_point: "N/A",
      frame_start_date:  customer.frame_start_date != nil ? (out_of_range_date == true ? "N/A" : customer.frame_start_date.strftime('%Y/%m/%d')) : "N/A",
      frame_end_date:  customer.frame_end_date != nil ? (out_of_range_date == true ? "N/A" : customer.frame_end_date.strftime('%Y/%m/%d')) :  "N/A"
    }
    
    if res_data.result
      res_data_json = JSON.parse(res_data.data)['data']
      if !res_data_json.nil?
        point_data[:loyalty_point] = res_data_json['LoyaltyPoints']
        point_data[:loyalty_point_today] = res_data_json['LoyaltyPoints_Today']
        point_data[:loyalty_point_weekly] = res_data_json['LoyaltyPoints_Week']
        point_data[:loyalty_point_current] = res_data_json['LoyaltyPoints_Current']
        point_data[:loyalty_point_month] = res_data_json['LoyaltyPoints_Month']
        point_data[:loyalty_point_today_slot] = res_data_json['LoyaltyPoints_Today_Slot']
        point_data[:loyalty_point_today_rltb] = res_data_json['LoyaltyPoints_Today_RLTB']
      end
    else
      return res_data
    end

    if res_data2.result
      res_data_json = JSON.parse(res_data2.data)['data']
      if !res_data_json.nil?
        point_data[:wallet] = res_data_json['Casshless_Credit']
        point_data[:fortune_credit] = res_data_json['Fortune_Credit']
        point_data[:credit_point] = res_data_json['Comp_Point']
      end
    else
      return res_data2
    end

    if customer.frame_start_date != nil && customer.frame_end_date != nil
      if res_data3.result
        res_data_json3 = JSON.parse(res_data3.data)['data']
        if !res_data_json.nil?
          point_data[:frame_point] = out_of_range_date == true ? "N/A" : res_data_json3['LoyaltyPoints_Frame'].to_s
        end
      else
        return res_data3
      end
    end
    
    # Get point by membership phase01 => phase02 unused
    # point_data = get_membership_by_point(point_data[:loyalty_point].to_i, point_data)
    point_data = get_pyramid_point_by_point(point_data[:loyalty_point_weekly].to_i, point_data)
    if customer.forename == 'Vegas01'
      point_data = JSON.parse(Setting.where('setting_key = ?', 'SETTING_POINT_USER_VEGAS_TEST').first!.setting_value)
      
      result.set_success_data(:ok, point_data)
      return result
    end
    result.set_success_data(:ok, point_data)
    
    return result
  end

  def get_data_customer_voucher(id)
    result = ResultHandler.new
    vouchers = []

    customer = Customer.find(id)
    voucher_data = get_customer_voucher_neon(customer.number)
    if voucher_data.instance_of? Array
      voucher_data.each do |item|
        voucher = {
          display_name: item[:display_name],
          is_valid: item[:is_valid],
          value: item[:value],
          voucher_id: item[:voucher_id],
          voucher_type: item[:voucher_type]
        }
        vouchers.push(voucher)
      end
    else
      voucher = {
        display_name: voucher_data[:display_name],
        is_valid: voucher_data[:is_valid],
        value: voucher_data[:value],
        voucher_id: voucher_data[:voucher_id],
        voucher_type: voucher_data[:voucher_type]
      }
      vouchers.push(voucher)
    end
    

    result.set_success_data(:ok, vouchers)
    
    return result
  end

  def get_data_customer_total_voucher(id)
    result = ResultHandler.new
    customer = Customer.find(id)
    total = 0
    vegas_internal_api = Setting.where('setting_key = ?', 'NEON_CRM_API').first!.setting_value
    res_data = get_content_from_url(vegas_internal_api + "/rest/v10/vouchers/search/" + customer.number.to_s, :get)

    if res_data.result
      res_data_json = JSON.parse(res_data.data)['vouchers']
      if !res_data_json.nil?
        res_data_json.each do |item|
          if item['voucher_status']['status'] == "Available"
            total = total + item['cash_value']['value'].to_i
          end         
        end
      end
    end
    if customer.forename == 'Vegas01'
      result.set_success_data(:ok, {total_voucher: 18})
      return result
    end
    result.set_success_data(:ok, {total_voucher: total})
    
    return result
  end

  def get_customer_voucher_neon(number)
    # create a client for the service
    neon_api = Setting.where('setting_key = ?', 'NEON_LOYALTY_API').first!.setting_value
    computer_name = Setting.where('setting_key = ?', 'NEON_COMPUTER_NAME').first!.setting_value
    client = Savon.client(wsdl: neon_api + '?wsdl', endpoint: neon_api)
    
    # puts client.operations
    xml = '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
            <Body>
                <GetActiveVouchersForCustomer xmlns="http://www.IntelligentGaming.co.uk">
                    <!-- Optional -->
                    <request>
                        <ComputerName xmlns="IG.Cms.Gateway.DataContracts">#{ComputerName}</ComputerName>
                        <CustomerNumber xmlns="IG.Cms.Gateway.DataContracts">#{CustomerNumber}</CustomerNumber>
                    </request>
                </GetActiveVouchersForCustomer>
            </Body>
          </Envelope>'
    xml = xml.gsub('#{ComputerName}', computer_name).gsub('#{CustomerNumber}', number.to_s)
    
    # call the 'GetActiveVouchersForCustomer' operation
    response = client.call(:get_active_vouchers_for_customer, xml: xml)
    
    data = response.body
    if data[:get_active_vouchers_for_customer_response][:get_active_vouchers_for_customer_result][:vouchers].nil?
      return []
    end
    return data[:get_active_vouchers_for_customer_response][:get_active_vouchers_for_customer_result][:vouchers][:crm_voucher]
  end

  def get_data_customer_jackpot_history(id)
    result = ResultHandler.new
    jackpot_history = []

    # customer = Customer.find(id)
    jp_history_name = Setting.where('setting_key = ?', 'VC_JP_HISTORY_NAME_INCLUDE').first!.setting_value
    vegas_internal_api = Setting.where('setting_key = ?', 'VC_INTERNAL_API').first!.setting_value

    end_date = Date.today
    start_date = end_date - 7.days
    req_body = {
      startDate: start_date.strftime('%Y-%m-%d'),
      endDate: end_date.strftime('%Y-%m-%d')
    }
    res_data = get_content_from_url(vegas_internal_api + "/api/jackpot_history", :post, req_body)

    if res_data.result
      res_data_json = JSON.parse(res_data.data)['data']
      if !res_data_json.nil?
        res_data_json.each do |item|
          if jp_history_name.include? item['Name']
            history = {
              id: 0,
              jp_date: item['HitGamingDate'],
              jp_game_name: item['Name'],
              mc_number: item['Machine_Number'],
              mc_name: item['Game_Theme'],
              jp_value: item['AmountPaidOut']
            }
            jackpot_history.push(history)
          end          
        end
      end
    end
    result.set_success_data(:ok, jackpot_history)
    
    return result
  end

  def get_data_customer_machine(id)
    result = ResultHandler.new
    machines = []

    customer = Customer.find(id)
    vegas_internal_api = Setting.where('setting_key = ?', 'VC_INTERNAL_API').first!.setting_value

    start_date = Date.today
    req_body = {
      date: start_date.strftime('%Y-%m-%d'),
      customer_number: customer.number
    }
    res_data = get_content_from_url(vegas_internal_api + "/api/machine_player", :post, req_body)

    if res_data.result
      res_data_json = JSON.parse(res_data.data)['data']
      if !res_data_json.nil?
        res_data_json.each do |item|
          if !machines.any?{|a| a[:machine_number] == item['Machine_Number']}
            machine = {
              machine_number: item['Machine_Number'],
              machine_name: item['Game']
            }
            machines.push(machine)
          end
        end
      end
    end

    result.set_success_data(:ok, machines)
    
    return result
  end

  def get_data_customer_by_date
    result = ResultHandler.new
    customers = []
    vegas_internal_api = Setting.where('setting_key = ?', 'VC_INTERNAL_API').first!.setting_value

    start_date = Date.today - 1.days
    end_date = Date.today
    req_body = {
      dateStart: start_date.strftime('%Y-%m-%d'),
      dateEnd: end_date.strftime('%Y-%m-%d')
    }
    res_data = get_content_from_url(vegas_internal_api + "/api/user_register_dates", :post, req_body)

    if res_data.result
      res_data_json = JSON.parse(res_data.data)['data']
      if !res_data_json.nil?
        res_data_json.each do |item|
          customer = Customer.new
          customer.age = item['age']
          customer.card_number = item['card_number'].gsub('100=', '')
          customer.cashless_balance = item['cashless_balance']
          customer.colour = item['colour']
          customer.colour_html = item['colour_html']
          customer.comp_balance = item['comp_balance']
          customer.comp_status_colour = item['comp_status_colour']
          customer.comp_status_colour_html = item['comp_status_colour_html']
          customer.forename = item['forename']
          customer.freeplay_balance = item['freeplay_balance']
          customer.gender = item['gender'] == 1 ? "Male" : "Female"
          customer.has_online_account = item['has_online_account']
          customer.hide_comp_balance = item['hide_comp_balance']
          customer.is_guest = item['is_guest'] == nil ? 1 : 0
          customer.loyalty_balance = item['loyalty_balance']
          customer.loyalty_points_available = item['loyalty_points_available']
          customer.membership_type_name = item['membership_type_name']
          customer.middle_name = item['middle_name']
          customer.number = item['number']
          customer.player_tier_name = item['player_tier_name']
          customer.player_tier_short_code = item['player_tier_short_code']
          customer.premium_player = item['premium_player']
          customer.surname = item['surname']
          customer.title = item['title']
          customer.valid_membership = item['valid_membership'] == nil ? 1 : 0
          customer.date_of_birth = item['date_of_birth']
          customer.membership_last_issue_date = item['membership_last_issue_date']
          customers.push(customer)
        end
        synchronize_customer(customers)
      end
    end

    result.set_success_data(:ok, customers)
    
    return result
  end

  def get_cardnumber_by_number(number)
    vegas_internal_api = Setting.where('setting_key = ?', 'VC_INTERNAL_API').first!.setting_value
    res_data = get_content_from_url(vegas_internal_api + "/api/card_number/" + number.to_s, :get, req_body)

    if res_data.result
      res_data_json = JSON.parse(res_data.data)
      if !res_data_json.nil?
        return res_data_json[res_data_json.length - 1]['TrackData'].to_i
      end
    end
  end

  def synchronize_customer(customer_data)
    neon_api =  Setting.where('setting_key = ?', 'NEON_LOYALTY_API').first!.setting_value
    computer_name = Setting.where('setting_key = ?', 'NEON_COMPUTER_NAME').first!.setting_value
    customer_data.each do |item|
      # Get customer extra info by card
      customer_extra_info = get_customer_by_card(item[:card_number], neon_api, computer_name)
      
      # if customer_extra_info == nil
      #   get_cardnumber_by_number(item[:card_number], neon_api, computer_name)
      # end

        customer = Customer.find_by(number: item[:number])
        if customer.nil?
          # Create a new customer
          customer = Customer.new
          customer.age = customer_extra_info == nil ? item[:age] : customer_extra_info[:age]
          customer.card_number = item[:card_number]
          customer.cashless_balance = item[:cashless_balance]
          customer.colour = customer_extra_info == nil ? item[:colour] : customer_extra_info[:colour]
          customer.colour_html = item[:colour_html]
          customer.comp_balance = item[:comp_balance]
          customer.comp_status_colour = item[:comp_status_colour]
          customer.comp_status_colour_html = item[:comp_status_colour_html]
          customer.forename = item[:forename]
          customer.freeplay_balance = item[:freeplay_balance]
          customer.gender = item[:gender]
          customer.has_online_account = customer_extra_info == nil ? item[:has_online_account] : customer_extra_info[:has_online_account]
          customer.hide_comp_balance = item[:hide_comp_balance]
          customer.is_guest = item[:is_guest]
          customer.loyalty_balance = customer_extra_info == nil ? item[:loyalty_balance] : customer_extra_info[:loyalty_balance]
          customer.loyalty_points_available = customer_extra_info == nil ? item[:loyalty_points_available] : customer_extra_info[:loyalty_points_available]
          customer.membership_type_name = customer_extra_info == nil ? item[:membership_type_name] : customer_extra_info[:membership_type_name]
          customer.middle_name = item[:middle_name]
          customer.number = item[:number]
          customer.player_tier_name = item[:player_tier_name]
          customer.player_tier_short_code = item[:player_tier_short_code]
          customer.premium_player = item[:premium_player]
          customer.surname = item[:surname]
          customer.title = item[:title]
          customer.valid_membership = item[:valid_membership]
          customer.date_of_birth = customer_extra_info == nil ? item[:date_of_birth] : customer_extra_info[:date_of_birth]
          customer.membership_last_issue_date = customer_extra_info == nil ? item[:membership_last_issue_date] : customer_extra_info[:membership_last_issue_date]
          customer.nationality = customer_extra_info == nil ? "" : customer_extra_info[:nationality_name]
          customer.frame_start_date = item[:frame_start_date]
          customer.frame_end_date = item[:frame_end_date]
          customer.last_update_frame_point = item[:last_update_frame_point]
          # Create a new user
          user = User.find_by(email: item[:number])
          if user.nil?
            user = User.new
            user.email = item[:number]
            user.name = item[:forename]
            user.password = get_pin_code_customer_default(customer.date_of_birth) # PIN code default
            user.skip_confirmation!
            ActiveRecord::Base::transaction do
              _ok = user.save
              if _ok
                customer.user_id = user.id
              else
                logger.debug "Create user customer number fail: #{item[:number]}"
                raise ActiveRecord::Rollback, result = false unless _ok
              end
            end
            
            # Create user_group
            user_group = UserGroup.new
            user_group.user_id = user.id
            user_group.group_id = 2
            ActiveRecord::Base::transaction do
              _ok = user_group.save
              if _ok
                #
              else
                logger.debug "Create user group number fail: #{item[:number]}"
                raise ActiveRecord::Rollback, result = false unless _ok
              end
            end
          end

          if customer_extra_info != nil
            # Create a new customer image
            image_base64 = customer_extra_info[:picture]
            if image_base64 != nil
              attachment = get_attachment_base64(image_base64, customer.number)
              if attachment != nil
                ActiveRecord::Base::transaction do
                  _ok = create_attachment_file(attachment)
                  if _ok
                    customer.attachment_id = attachment.id
                  else
                    logger.debug "Create customer attachment number fail: #{item[:number]}"
                    raise ActiveRecord::Rollback, result = false unless _ok
                  end
                end
              end
            end
          else
            customer.attachment_id = 0
          end

          ActiveRecord::Base::transaction do
            _ok = customer.save
            if _ok
              #
            else
              logger.debug "Create customer number fail: #{item[:number]}"
              raise ActiveRecord::Rollback, result = false unless _ok
            end
          end

        else
          # Update a existed customer
          customer.age = customer_extra_info == nil ? item[:age] : customer_extra_info[:age]
          customer.card_number = item[:card_number]
          customer.cashless_balance = item[:cashless_balance]
          customer.colour = customer_extra_info == nil ? item[:colour] : customer_extra_info[:colour]
          customer.colour_html = item[:colour_html]
          customer.comp_balance = item[:comp_balance]
          customer.comp_status_colour = item[:comp_status_colour]
          customer.comp_status_colour_html = item[:comp_status_colour_html]
          customer.forename = item[:forename]
          customer.freeplay_balance = item[:freeplay_balance]
          customer.gender = item[:gender]
          customer.has_online_account = customer_extra_info == nil ? item[:has_online_account] : customer_extra_info[:has_online_account]
          customer.hide_comp_balance = item[:hide_comp_balance]
          customer.is_guest = item[:is_guest]
          customer.loyalty_balance = customer_extra_info == nil ? item[:loyalty_balance] : customer_extra_info[:loyalty_balance]
          customer.loyalty_points_available = customer_extra_info == nil ? item[:loyalty_points_available] : customer_extra_info[:loyalty_points_available]
          customer.membership_type_name = customer_extra_info == nil ? item[:membership_type_name] : customer_extra_info[:membership_type_name]
          customer.middle_name = item[:middle_name]
          customer.number = item[:number]
          customer.player_tier_name = item[:player_tier_name]
          customer.player_tier_short_code = item[:player_tier_short_code]
          customer.premium_player = item[:premium_player]
          customer.surname = item[:surname]
          customer.title = item[:title]
          customer.valid_membership = item[:valid_membership]
          customer.date_of_birth = customer_extra_info == nil ? item[:date_of_birth] : customer_extra_info[:date_of_birth]
          customer.membership_last_issue_date = customer_extra_info == nil ? item[:membership_last_issue_date] : customer_extra_info[:membership_last_issue_date]
          customer.nationality = customer_extra_info == nil ? "" : customer_extra_info[:nationality_name]
          customer.frame_start_date = item[:frame_start_date]
          customer.frame_end_date = item[:frame_end_date]
          customer.last_update_frame_point = item[:last_update_frame_point]
          # Create a new customer image
          #image_base64 = customer_extra_info[:picture]
          # Check customer picture existed
          # if !customer.attachment_id.nil? && customer.attachment_id != 0
          #   # TODO check image_base64 vs image base64 of existed attachment
          # end

          ActiveRecord::Base::transaction do
            _ok = customer.save
            raise ActiveRecord::Rollback, result = false unless _ok
          end
        end
      
    end
  end

  def get_customer_by_number(number, _neon_api = nil, _computer_name = nil)
    # create a client for the service
    neon_api = _neon_api != nil ? _neon_api : Setting.where('setting_key = ?', 'NEON_API').first!.setting_value
    computer_name = _computer_name != nil ? _computer_name :  Setting.where('setting_key = ?', 'NEON_COMPUTER_NAME').first!.setting_value
    client = Savon.client(wsdl: neon_api + '?wsdl', endpoint: neon_api)
    # puts client.operations
    xml = '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
            <Body>
                <GetCustomer xmlns="http://www.IntelligentGaming.co.uk">
                    <!-- Optional -->
                    <request>
                        <ComputerName xmlns="IG.Cms.Gateway.DataContracts">#{ComputerName}</ComputerName>
                        <CardNumber xmlns="IG.Cms.Gateway.DataContracts"></CardNumber>
                        <CustomerNumber xmlns="IG.Cms.Gateway.DataContracts">#{CustomerNumber}</CustomerNumber>
                    </request>
                </GetCustomer>
            </Body>
          </Envelope>'
    xml = xml.gsub('#{ComputerName}', computer_name).gsub('#{CustomerNumber}', number.to_s)
    
    # call the 'GetCustomerByCard' operation
    response = client.call(:get_customer, xml: xml)
    
    data = response.body
    return data[:get_customer_response][:get_customer_result][:customer]
  end

  # Validate input param destroy
  def check_params_change_password(_request_body)
    result = ResultHandler.new
    user_id = _request_body['user_id']
    password = _request_body['new_password']
    confirm_password = _request_body['confirm_password']

    if (is_blank(user_id) || is_blank(password) || is_blank(confirm_password))
      result.set_error_data(:bad_request, I18n.t('messages.invalid_param'))
      return result
    end

    user = User.where('id = ?', user_id.to_i).first
    if user == nil
      result.set_error_data(:not_found, I18n.t('messages.user_not_found'))
      return result
    end

    if password != confirm_password
      result.set_error_data(:not_found, I18n.t('messages.password_change_not_match'))
      return result
    end

    return result
  end

  def change_password_user(_request_body)
    result = ResultHandler.new
    user_id = _request_body['user_id']
    password = _request_body['new_password']

    user = User.select('users.email, users.id').where('id = ?', current_user.id.to_i).first
    user.email = user.email
    user.password = password
    user.skip_confirmation!
    ActiveRecord::Base::transaction do
      _ok = user.save
      if _ok
        result.set_success_data(:ok, user)
      else
        result.set_error_data(:bad_request, I18n.t('messages.error_403_info'))
      end
    end
    return result
  end

  def validate_update_avatar(customer_id, attachment_id)
    result = ResultHandler.new
    if (is_blank(customer_id) || is_blank(attachment_id))
      result.set_error_data(:bad_request, I18n.t('messages.invalid_param'))
      return result
    end

    return result
  end

  def update_avatar_customer(customer_id, attachment_id)
    result = ResultHandler.new
    customer = Customer.find(customer_id.to_i)
    if customer != nil
      customer.attachment_id = attachment_id.to_i
      customer.save!
    end
    result.set_success_data(:ok, customer)
    return result
  end
  
  def synchronize_frame_data()
    url_file = Setting.where('setting_key = ?', 'URL_FRAME_POINT_FILE_CONFIG').first().setting_value.to_s
    url = URI.parse(url_file)
    req = Net::HTTP.new(url.host, url.port)
    res = req.request_head(url.path)
    if res.code != "200"
      send_mail_file_not_found(url_file)
    else
      spreadsheet = Roo::Spreadsheet.open(url_file)
      customerList = []
      customer_err_date = []
      header = spreadsheet.sheet(0).row(1)
      (2..spreadsheet.sheet(0).last_row).map do |i|
        row = Hash[[header, spreadsheet.sheet(0).row(i)].transpose]
        if (safe_date(row["END"]) && safe_date(row["START"]))
          customerList.push(CustomerFrameDateData.new(row["#-MB"], row["START"], row["END"]))
        else
          customer_err_date.push({ROW: i, MB: row["#-MB"], START: row["START"], END: row["END"]})
        end
      end
  
      update_frame_point(customerList, customer_err_date)
    end
  end

  def validate_change_phone(_user_id, _request_body)
    result = ResultHandler.new
    user_id = _user_id.to_i
    phone = _request_body['phone']
    
    if (is_blank(user_id))
      result.set_error_data(:bad_request, I18n.t('messages.object_to_required'))
      return result
    end

    user = User.find(user_id)
    if user == nil
      result.set_error_data(:not_found, I18n.t('messages.user_not_found'))
      return result
    end

    if (is_blank(phone))
      result.set_error_data(:bad_request, I18n.t('messages.object_to_required'))
      return result
    end

    return result
  end
  
  def update_phone_user(_user_id, phone)
    result = ResultHandler.new
    user = User.find(_user_id.to_i)
    if user != nil
      user.phone = phone
      user.save!
    end
    result.set_success_data(:ok, user)
    return result
  end

  def update_language_user(_user_id, language)
    result = ResultHandler.new
    user = User.find(_user_id.to_i)
    if user != nil
      user.language = language
      user.save!
    end
    result.set_success_data(:ok, user)
    return result
  end

  def update_setting_user(_user_id, setting)
    result = ResultHandler.new
    user = User.find(_user_id.to_i)
    if user != nil
      user.setting = setting
      user.save!
    end
    result.set_success_data(:ok, user)
    return result
  end

  private
    def get_membership_by_point(_point, _point_data)
      data = Membership.where('point >= ?', _point.to_i).limit(2)
      if data.length > 0
        _point_data[:loyalty_point_next_1] = data[0][:point] - _point.to_i
        _point_data[:loyalty_point_sub_next_1] = data[0][:sub]
        if data[1].nil?
          _point_data[:loyalty_point_next_2] = _point_data[:loyalty_point_next_1]
          _point_data[:loyalty_point_sub_next_2] = _point_data[:loyalty_point_sub_next_1]
        else
          _point_data[:loyalty_point_next_2] = data[1][:point] - _point.to_i
          _point_data[:loyalty_point_sub_next_2] = data[1][:sub]
        end
      else
        _point_data[:loyalty_point_next_1] = _point
        _point_data[:loyalty_point_sub_next_1] = "Double One+"
        _point_data[:loyalty_point_next_2] = _point
        _point_data[:loyalty_point_sub_next_2] = "Double One+"
      end
      return _point_data
    end

    def get_pyramid_point_by_point(_point, _point_data)
      data = PyramidPoint.where('min_point <= ?', _point.to_i).order('min_point desc').first
      data_next_range = PyramidPoint.where('min_point >= ?', _point.to_i).order('min_point asc').first
      max_point = PyramidPoint.select('prize, MAX(min_point) as min_point, max_point').group('id').order('min_point desc').first
      min_point = PyramidPoint.select('prize, MIN(min_point) as min_point').group('id').first
      if data != nil
        _point_data[:loyalty_point_weekly_next_draw] = data_next_range != nil ? (data_next_range[:min_point] - _point.to_i) : data[:max_point] - _point.to_i
        _point_data[:loyalty_point_weekly_range] = data[:prize]
        if _point < min_point[:min_point]
          _point_data[:loyalty_point_weekly_next_draw] = min_point[:min_point] - _point.to_i
          _point_data[:loyalty_point_weekly_range] = "$0"
        end
      elsif _point > max_point[:min_point]
        _point_data[:loyalty_point_weekly_next_draw] = max_point[:max_point] - _point.to_i
        _point_data[:loyalty_point_weekly_range] = max_point[:prize]
      end
      
      return _point_data
    end

    def lock_customer_by_user_id(_user_id)
      result = ResultHandler.new
      user_id = _user_id.to_i
      user = User.select('users.*').joins(:customer).where('customers.id = ?', user_id.to_i).first
      if !user.nil?
        # user.locked_at = Time.now.utc
        user.lock_access!({send_instructions: false})
        result.set_success_data(:ok, user)
        return result
      end
  
      result.set_success_data(:ok, user)
      return result
    end

    def sign_out_user(_user_id)
      result = ResultHandler.new
      user_id = _user_id.to_i
      user = User.find(user_id)   
      if !user.nil?
        user[:session_token] = SecureRandom.uuid
        user.save
        return result
      end
  
      result.set_success_data(:ok, "")
      return result
    end

    def get_data_voucher_customer_from_crm_neon(id)
      result = ResultHandler.new
      voucher_customer = []
      customer = Customer.find(id)
      vegas_internal_api = Setting.where('setting_key = ?', 'NEON_CRM_API').first!.setting_value
      res_data = get_content_from_url(vegas_internal_api + "/rest/v10/vouchers/search/" + customer.number.to_s, :get)
  
      if res_data.result
        res_data_json = JSON.parse(res_data.data)['vouchers']
        if !res_data_json.nil?
          res_data_json.each do |item|
            if item['voucher_status']['status'] == "Available"
              voucher = {
                voucher_name: item['voucher_name']['value'],
                voucher_type: item['redemption_type']['name'],
                messages: item['redemption_message']['value'],
                voucher_status: item['voucher_status']['status'],
                cash_value: item['cash_value']['value'] == nil ? 0 : item['cash_value']['value'].to_i
              }
              voucher_customer.push(voucher)
            end         
          end
        end
      end
      result.set_success_data(:ok, voucher_customer)
      
      return result
    end
    
    def update_frame_point(customerList, customer_err_date)
      result = true
      customers = []
      if(customerList.length <= 0)
        return false
      end
      neon_api = Setting.where('setting_key = ?', 'NEON_API').first!.setting_value
      computer_name = Setting.where('setting_key = ?', 'NEON_COMPUTER_NAME').first!.setting_value
      customerList.each do |item_data|
        customerNew = Customer.find_by(number: item_data.number.to_i)
        if customerNew.nil? == false
          customerNew.frame_start_date = item_data.frame_start_date
          customerNew.frame_end_date = item_data.frame_end_date
          customerNew.last_update_frame_point = DateTime.now
          customers.push(customerNew)
        else
          item = get_customer_by_number(item_data.number.to_i, neon_api, computer_name)
          if !item.nil?
            customer = Customer.new
            customer.age = item[:age]
            customer.card_number = item[:card_number]
            customer.cashless_balance = item[:cashless_balance]
            customer.colour = item[:colour]
            customer.colour_html = item[:colour_html]
            customer.comp_balance = item[:comp_balance]
            customer.comp_status_colour = item[:comp_status_colour]
            customer.comp_status_colour_html = item[:comp_status_colour_html]
            customer.forename = item[:forename]
            customer.freeplay_balance = item[:freeplay_balance]
            customer.gender = item[:gender]
            customer.has_online_account = item[:has_online_account]
            customer.hide_comp_balance = item[:hide_comp_balance]
            customer.is_guest = item[:is_guest]
            customer.loyalty_balance = item[:loyalty_balance]
            customer.loyalty_points_available = item[:loyalty_points_available]
            customer.membership_type_name = item[:membership_type_name]
            customer.middle_name = item[:middle_name]
            customer.number = item[:number]
            customer.player_tier_name = item[:player_tier_name]
            customer.player_tier_short_code = item[:player_tier_short_code]
            customer.premium_player = item[:premium_player]
            customer.surname = item[:surname]
            customer.title = item[:title]
            customer.valid_membership = item[:valid_membership]
            customer.frame_start_date = item_data.frame_start_date
            customer.frame_end_date = item_data.frame_end_date
            customer.last_update_frame_point = DateTime.now
            customers.push(customer)
          end
        end
      end
      synchronize_customer(customers)
      send_mail_frame_point(customerList, customer_err_date)
      return result
    end

    def send_mail_frame_point(customerList, customer_err_date)
      mail_to = Setting.where('setting_key = ?', 'EMAIL_ALERT_CONFIG').first().setting_value.to_s
      sum_frame = customerList.length + customer_err_date.length
      time_now = Time.now
      mail_subject = "E-Vegas - Update Frame Date - " + time_now.strftime("%Y-%m-%d")
      mail_body = '<br/>Thông báo cập nhật Frame Date ngày ' + time_now.strftime("%Y-%m-%d %H:%M")
      mail_body += '<br/>Tổng số dữ liệu cập nhật: ' + sum_frame.to_s
      mail_body += '<br/>Số dữ liệu không cập nhật được: ' + customer_err_date.length.to_s
      mail_body += '<br/>Danh sách dữ liệu sai định dạng thời gian trong file excel:'
      mail_body += '<br/><ul>'
      customer_err_date.each do |item|
        mail_body += '<li> Row '+ item[:ROW].to_s + ' --- ' + 'MB: ' + item[:MB].to_s + ' --- '  + 'START: ' + item[:START].to_s + ' --- ' + 'END: ' + item[:END].to_s + '</li>'
      end
      mail_body += '</ul>'
      mail_body += '<br/>Best Regards,'
      SystemMailer.send_email(mail_to, mail_subject, mail_body).deliver_now
    end

    def send_mail_file_not_found(url)
      mail_to = Setting.where('setting_key = ?', 'EMAIL_ALERT_CONFIG').first().setting_value.to_s
      time_now = Time.now
      mail_subject = "E-Vegas - Update Frame Date - " + time_now.strftime("%Y-%m-%d")
      mail_body = '<br/>Vui lòng kiểm tra không tìm thấy file frame date trên sever ' + url.path.to_s 
      mail_body += '<br/>Best Regards,'
      SystemMailer.send_email(mail_to, mail_subject, mail_body).deliver_now
    end
end

class CustomerFrameDateData
  attr_accessor :number, :frame_start_date, :frame_end_date

  def initialize(number, frame_start_date, frame_end_date)
    @number = number
    @frame_start_date = DateTime.parse(frame_start_date)
    @frame_end_date = DateTime.parse(frame_end_date)
  end
end