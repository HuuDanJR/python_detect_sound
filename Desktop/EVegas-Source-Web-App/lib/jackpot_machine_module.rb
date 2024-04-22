require 'faye/websocket'
require 'eventmachine'

module JackpotMachineModule
  include CommonModule
  include DaoModule
  include LogMailModule
  
  JACKPOT_MACHINE_ATTRIBUTE = ClassAttribute.new
  JACKPOT_MACHINE_ATTRIBUTE.clazz = JackpotMachine
  JACKPOT_MACHINE_ATTRIBUTE.object_key = "jackpot_machine"
  JACKPOT_MACHINE_ATTRIBUTE.filter_params = ["search", "by_jp_date_from", "by_jp_date_end"]
  JACKPOT_MACHINE_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  JACKPOT_MACHINE_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  JACKPOT_MACHINE_ATTRIBUTE.include_object_params = {
    "jackpot_game_type" => ["id", "name"]
  }

  
  # Get all object from database
  def get_all_object_override(clazz, clazz_filter_params, input_params, query = nil, order_field = nil)
    result = ResultHandler.new
    # Get query data
    query_select = return_data_param_field(input_params['fields'])
    query_order = return_data_param_order(input_params['sort'])
    query_limit = return_data_param_limit(input_params['limit'])
    query_offset = return_data_param_offset(input_params['offset'])
    query_include = return_data_param_include(input_params['include'])

    logger.debug "Get all object: #{clazz}"
    logger.debug "Input params: #{input_params}"
    begin
      records = clazz.filter(filtering_params(params, clazz_filter_params))
      # total = records.count
      query_include.each do |item|
        records = records.includes(item)
      end
      if !query.nil?
        records = records.where(query)
      end
      records = records.select(query_select)
                    .order('jp_date desc, jp_value desc')
                    .order(order_field)
                    .limit(query_limit)
                    .offset(query_offset)
      
      result.set_success_data(:ok, records)
    rescue ActiveRecord::StatementInvalid => e
      result.set_error_data(:internal_server_error, e.to_s)
    rescue StandardError => e
      result.set_error_data(:internal_server_error, e.to_s)
    end

    return result
  end

  def check_validate_date_from_and_date_to(date_from, date_to)
    result = ResultHandler.new
    if is_blank(date_from) || is_blank(date_to)
      result.set_error_data(:bad_request, 'Invalid Params')
      return result
    end
    return result
  end

  def get_data_jp_machine_by_date(_date_from, _date_to, limit, offset)
    result = ResultHandler.new
    date_from = DateTime.parse(_date_from)
    date_to = DateTime.parse(_date_to).change({ hour: 23, min: 59, sec: 59 })

    records = JackpotMachine.joins(:jackpot_game_type => [])
              .select('jackpot_machines.id, jackpot_machines.mc_number, jackpot_machines.mc_name, jackpot_machines.jp_date, jackpot_machines.jp_value, jackpot_game_types.name as jp_game_name')
              .where("jackpot_machines.jp_date BETWEEN ? AND ?", date_from.strftime("%Y-%m-%d %H:%M:%S"), date_to.strftime("%Y-%m-%d %H:%M:%S"))
              .order('jackpot_machines.jp_date desc')
              .limit(limit)
              .offset(offset)
    result.set_success_data(:ok, records)
    return result
  end

  def get_data_jp_real_time()
    result = ResultHandler.new
    data = JackpotRealTime.order('id desc').first!
    datatmp = JSON.parse(eval(data[:data]).to_json)
    records = {
      last_update: datatmp['last_update'].to_s,
      data: []
    }
    datatmp["data"].each do |item|
      record = {
        id: item["id"].to_i,
        name: item["name"].to_s,
        value: item["value"].to_f.round(2),
        max: item["max"],
        min: item["min"],
        index: item["index"]
      }
      records[:data].push(record)
    end
    result.set_success_data(:ok, records)
    return result
  end

  def sync_data_jp_real_time()
    result = ResultHandler.new
    websocket_url = Setting.where('setting_key = ?', 'NEON_JACKPOT_GATEWAY').first!.setting_value
    jp_data = Setting.where('setting_key = ?', 'JACKPOT_REAL_TIME').first!.setting_value
    jp_data_val = JSON.parse(jp_data)
    str_req = '<?xml version="1.0" encoding="UTF-8"?>
    <InformationRequest xmlns="http://IntelligentGaming/ThirdParty/Jackpots">
      <ComputerName>win10-tech</ComputerName>
    </InformationRequest>'

    records = {
      last_update: "",
      data: []
    }

    EM.run {
      ws = Faye::WebSocket::Client.new(websocket_url)

      ws.on :open do |event|
        p [:open]
        ws.send(str_req)
      end

      ws.on :message do |event|
        # puts 'received message'
        # p [:message, event.data]

        # TODO: need convert object
        record = {
          name: "",
          value: "",
          max: "",
          min: ""
        }
        xml_doc = Nokogiri::XML.parse(event.data)
        records[:last_update] = xml_doc.at_css("InformationBroadcast").attr("BroadcastRequestDateTime").to_s
        jackpot_list = xml_doc.at_css("JackpotList")
        jackpot_list.css("Jackpot").each do |item|
          puts item.to_json
          if item.attr("Name").to_s != "Frequent"
            record = {
              id: item.attr("Id").to_i,
              name: item.attr("Name").to_s,
              value: item.attr("Value").to_f.round(2),
              max: "$0",
              min: "$0",
              index: 100
            }
            check_item = check_item_jp_exists(jp_data_val, item.attr("Name").to_s)
            if check_item != nil
              record[:max] = check_item['max']
              record[:min] = check_item['min']
              record[:index] = check_item['index']
            else
              record[:max] = "$0"
              record[:min] = "$0"
            end
            
            records[:data].push(record)
          end
        end
        # Close websocket
        ws.close
        records[:data] = records[:data].sort_by! {|u| u[:index]}
        jp_realtime = JackpotRealTime.new()
        jp_realtime.data = records
        jp_realtime.save
        result.set_success_data(:ok, jp_realtime)
        return result
      end

      ws.on :close do |event|
        p [:close, event.code, event.reason]
        ws = nil
      end
        ws.send(str_req)
    }
    return result
  end

  def check_item_jp_exists(jp_data_val, jp_name)
    jp_data_val.each do |item|
      if jp_name.to_s.strip.upcase == item['name'].to_s.strip.upcase
        return item
      end
    end
    return nil
  end

  def get_data_jackpot_machine_from_neon()
    vegas_internal_api = Setting.where('setting_key = ?', 'VC_INTERNAL_API').first!.setting_value
    setting_config = JSON.parse(Setting.where('setting_key = ?', 'JACKPOT_MACHINE_SYNC_NEON_CONFIG').first!.setting_value)
    url_jackpot_machine = Setting.where('setting_key = ?', 'URL_JACKPOT_MACHINE_SYNC_NEON').first!.setting_value
    date_now = Time.zone.now
    req_body = {
      date: date_now.strftime('%Y-%m-%d')
    }
    res_data = get_content_from_url_neon(vegas_internal_api + url_jackpot_machine, :post, req_body, "jackpot_machines")
    if res_data.result
      if !res_data.data.nil? && res_data.data != ""
        res_data_json = JSON.parse(res_data.data).sort_by { |entry| entry[:AlertID] }
        if !res_data_json.nil?
          res_data_json.each do |item|
            match_val = item['Detail'].match(/[$](\d{1,3}(?:,\d{3})*(\.\d{1,2})?)/)
            jp_value = match_val[1].gsub(',', '').to_f if match_val
            match_number = item['Item'].match(/(\d+)/)
            jp_number = match_number[1].to_i if match_number
            match_level = item['Detail'].match(/Level (\d+)/)
            mystery_level = match_level[1] if match_level
            jp_date_tmp = DateTime.parse(item['GamingDate'])
            jp_date = Date.new(jp_date_tmp.year, jp_date_tmp.month, jp_date_tmp.day)
            game_type_str = ""
            if setting_config['number'].to_a.include? jp_number
              game_type_str = setting_config['value'].to_s
            else
              game_type_str = "Slot"
            end
            
            game_type = JackpotGameType.where('name = ?', item['GameTheme']).first
            if game_type == nil
              game_type = JackpotGameType.new
              game_type.name = item['GameTheme']
              game_type.created_at = date_now
              game_type.updated_at = date_now
              if game_type.save
                game_type = game_type
              end
            end

            jackpot_update = JackpotMachine.where('CAST(jp_value AS DECIMAL) = CAST(? AS DECIMAL) AND mc_number = ? AND mc_name = ? AND jp_date = ? AND jackpot_game_type_id = ?', 
              jp_value, jp_number.to_i, game_type_str.to_s, jp_date, game_type.id).first
            # puts jackpot_update.to_json
            
            if jackpot_update != nil
              # puts "update"
            else
              # puts "create"
              jackptmc = JackpotMachine.new
              jackptmc.mc_number = jp_number
              jackptmc.mc_name = game_type_str
              jackptmc.jp_date = jp_date
              jackptmc.jp_value = jp_value.to_f
              jackptmc.jackpot_game_type_id = game_type.id
              jackptmc.created_at = date_now
              jackptmc.updated_at = date_now
              jackptmc.mystery_jackpot_level = mystery_level.to_i
              # puts jackptmc.to_json
              jackptmc.save
            end
          end
        end
      end
    end
  end


  def get_data_detail_jp_real_time(_number)
    result = ResultHandler.new
    realtime_data = []
    vegas_internal_api = Setting.where('setting_key = ?', 'VC_INTERNAL_API').first!.setting_value
    date_now = Time.zone.today
    start_date = date_now - 90.days
    req_body = {
      startDate: start_date.strftime('%Y-%m-%d'),
      endDate: date_now.strftime('%Y-%m-%d'),
      id: _number.to_s
    }
    res_data = get_content_from_url_neon(vegas_internal_api + "/api/jackpot_history_id", :post, req_body, "jackpot_history_id")
    if res_data.result
      if !res_data.data.nil? && res_data.data != ""
        record_data = JSON.parse(res_data.data)["data"]
        if !record_data.nil? && record_data.length > 0
          record_data.each do |item|
            date_parse = DateTime.parse(item['HitGamingDate'])
            hit_gaming_date = Time.new(date_parse.year, date_parse.month, date_parse.day, date_parse.hour, date_parse.minute, date_parse.second)
            date_parse_2 = DateTime.parse(item['HitDateTime'])
            hit_date_time = Time.new(date_parse_2.year, date_parse_2.month, date_parse_2.day, date_parse_2.hour, date_parse_2.minute, date_parse_2.second)
            real_data = {
              name: item["Name"].to_s,
              game_theme: item["Game_Theme"].to_s,
              amount_paid_out: item["AmountPaidOut"].to_f.round(2),
              minimum_hit_value: item["MinimumHitValue"].to_s,
              hit_gaming_date: hit_gaming_date,
              hit_date_time: hit_date_time

            }
            realtime_data.push(real_data)
          end
        end
      end
    end

    result.set_success_data(:ok, realtime_data)
    
    return result
  end

  def get_data_jjbx_detail(level_jp)
    result = ResultHandler.new
    jjbx_ids = JSON.parse(Setting.where('setting_key = ?', 'JACKPOT_MACHINE_SYNC_NEON_CONFIG').first!.setting_value)
    jjbx_ids = jjbx_ids['number'].join(", ")
    jp_data = JackpotMachine.select('id, UPPER(mc_name) as name, UPPER(mc_name) as game_theme, jp_value as amount_paid_out, jp_value as hit_gaming_date, jp_date as hit_date_time, jp_value as minimum_hit_value, jp_date as hit_gaming_date')
                            .where("mc_number in (#{jjbx_ids})").order('jp_date desc').limit(10).offset(0)
    if level_jp.to_i > 0
      jp_data = jp_data.where('mystery_jackpot_level = ?', level_jp.to_i)
    end
    jp_data = jp_data.limit(10).offset(0)
    result.set_success_data(:ok, jp_data)

    return result
  end

  def get_content_from_url_neon(_url, _method, _payload = nil, type_send)
    result = ResultHandler.new
    begin
      response = RestClient::Request.execute(
        method: _method, 
        url: _url, 
        payload: _payload,
        headers: { :accept => :json, content_type: :json },
        timeout: ENV['TIMEOUT_REQUEST'].to_i)
      result.set_success_data(:ok, response)
    rescue RestClient::ExceptionWithResponse => err
      if type_send == "jackpot_machines"
        alert_jackpot_machines(_url)
      else
        alert_jackpot_machines_detail(_url)
      end
      result.set_error_data(:service_unavailable, I18n.t('messages.can_not_connect_to_server'))
    rescue StandardError => e
      if type_send == "jackpot_machines"
        alert_jackpot_machines(_url)
      else
        alert_jackpot_machines_detail(_url)
      end
      result.set_error_data(:service_unavailable, I18n.t('messages.can_not_connect_to_server') + hostname)
    end
    return result
  end

end