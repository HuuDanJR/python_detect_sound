module MysteryJackpotModule
  require 'action_view'
  include ActionView::Helpers::NumberHelper
  include CommonModule
  include DaoModule
  include NotificationModule

  MYSTERY_JACKPOT_ATTRIBUTE = ClassAttribute.new
  MYSTERY_JACKPOT_ATTRIBUTE.clazz = MysteryJackpot
  MYSTERY_JACKPOT_ATTRIBUTE.object_key = "mystery_jackpot"
  MYSTERY_JACKPOT_ATTRIBUTE.filter_params = []
  MYSTERY_JACKPOT_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  MYSTERY_JACKPOT_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  MYSTERY_JACKPOT_ATTRIBUTE.include_object_params = {}
  
  def sync_mystery_jackpot
    jp_history_name = Setting.where('setting_key = ?', 'VC_JP_HISTORY_NAME_INCLUDE').first!.setting_value
    vegas_internal_api = Setting.where('setting_key = ?', 'VC_INTERNAL_API').first!.setting_value
    jp_noti = Setting.where('setting_key = ?', 'MYSTERY_JACKPOT_NOTIFICATION').first!.setting_value
    end_date = Date.today
    start_date = end_date - 1.days
    req_body = {
      startDate: start_date.strftime('%Y-%m-%d'),
      endDate: end_date.strftime('%Y-%m-%d')
    }
    res_data = get_content_from_url_neon_mystery_jackpot(vegas_internal_api + "/api/jackpot_history", :post, req_body)

    if res_data.result
      res_data_json = JSON.parse(res_data.data)['data']
      if !res_data_json.nil?
        res_data_json.each do |item|
          if jp_history_name.include? item['Name']
            myjp_obj = MysteryJackpot.where('jp_occurrence_id = ? AND jp_value = ?', item['JackpotOccurrenceID'].to_i, item['AmountPaidOut']).first
            if myjp_obj == nil
              myjp = MysteryJackpot.new
              date_parse = DateTime.parse(item['HitDateTime'])
              myjp.jp_date = Time.new(date_parse.year, date_parse.month, date_parse.day, date_parse.hour, date_parse.minute, date_parse.second)
              myjp.jp_game_theme = item['Name']
              myjp.mc_number = item['Machine_Number']
              myjp.mc_name = item['Game_Theme']
              myjp.jp_value = item['AmountPaidOut']
              myjp.jp_occurrence_id = item['JackpotOccurrenceID'].to_i
              myjp.is_send = 0
              myjp.has_send = 0
              myjp.created_at = Time.now
              myjp.updated_at = Time.now
              if jp_noti.include? item['Name']
                myjp.has_send = 1
              end
              myjp.save
            end
          end          
        end
      end
    end
  end

  def send_notification_mystery_jackpot
    myjp_send = MysteryJackpot.where('has_send = 1 and is_send = 0').order('jp_date asc').first
    user_customers = User.select('users.id, users.language, customers.title, customers.forename').joins(:customer => [], :devices => []).where('devices.id > 0').order('devices.id desc').uniq
    if myjp_send == nil
      return
    end
    jp_value = number_to_currency(myjp_send.jp_value.round, precision: 0, delimiter: ',', format: '%n')
    title_noti = "$#{jp_value} #{myjp_send.jp_game_theme} Jackpot dropped"
    title_kr = "$#{jp_value} 금액의 #{myjp_send.jp_game_theme}잭팟이 드랍되었습니다."
    title_cn = "$#{jp_value} 金额的 #{myjp_send.jp_game_theme}大奖金刚掉落了"
    title_ja = "$#{jp_value}の#{myjp_send.jp_game_theme}が落ちました"
    
    short_noti = "The most recent #{myjp_send.jp_game_theme} Jackpot valued $#{jp_value} has just been hit."
    short_noti_kr = "방금 전 $#{jp_value} 금액의 #{myjp_send.jp_game_theme}잭팟이 드랍되었습니다."
    short_noti_cn = "刚才 $#{jp_value} 金额的 #{myjp_send.jp_game_theme}大奖金掉落了"
    short_noti_ja = "先ほど$#{jp_value}の#{myjp_send.jp_game_theme} Jackpotがドロップされました。"

    content_noti = "<p>The most recent <strong>#{myjp_send.jp_game_theme}</strong> Jackpot valued <strong>$#{jp_value}</strong> has just been hit by our lucky winner at machine number <strong>#{myjp_send.mc_number}</strong>, at <strong>#{myjp_send.jp_date.strftime("%T %d-%m-%Y")}</strong>.</p>
    <p>Jackpot fever is still in full swing at Vegas Club. Come and enjoy the thrill of hitting the Jackpots!</p>"
    content_noti_kr = "<p>방금 전<strong>$#{jp_value}</strong>상당의 <strong>#{myjp_send.jp_game_theme}</strong>잭팟이 <strong>#{myjp_send.mc_number}</strong>머신에서 <strong>#{myjp_send.jp_date.strftime("%T %d-%m-%Y")}</strong>에 드랍되었습니다.</p>
    <p>베가스에서는 아직도 잭팟의 열기가 뜨겁습니다. 방문하셔서 짜릿한 플레이를 함께 즐겨보세요!</p>"
    content_noti_cn = "<p>刚才<strong>$#{jp_value}</strong>金额的 <strong>#{myjp_send.jp_game_theme}</strong>大奖金在<strong>#{myjp_send.mc_number}</strong>号机器上<strong>#{myjp_send.jp_date.strftime("%T %d-%m-%Y")}</strong>点左右掉落了</p>
    <p>在维加斯娱乐场，大奖金的热情依然高涨。请访问，一起享受刺激的游戏！</p>"
    content_noti_ja = "<p>先ほど<strong>$#{jp_value}</strong>相当の<strong>#{myjp_send.jp_game_theme}</strong>Jackpotが<strong>#{myjp_send.mc_number}</strong>から<strong>#{myjp_send.jp_date.strftime("%T %d-%m-%Y")}</strong>にドロップしました。</p>
    <p>ベガスではまだまだジャックポット熱が続いています。 ぜひご来場いただき、スリリングなプレイをお楽しみください！</p>"

    myjp_send.is_send = 1
    myjp_send.save
    
    user_customers.each do |user|
      notification = Notification.new
      notification.user_id = user.id
      notification.source_id = myjp_send.id
      notification.source_type = "mystery_jackpots"
      notification.notification_type = 11
      notification.status = 1
      notification.status_type = 1
      notification.title = title_noti
      notification.title_ja = title_ja
      notification.title_kr = title_kr
      notification.title_cn = title_cn
      notification.content = content_noti
      notification.content_ja = content_noti_ja
      notification.content_kr = content_noti_kr
      notification.content_cn = content_noti_cn
      notification.short_description = short_noti
      notification.short_description_ja = short_noti_ja
      notification.short_description_kr = short_noti_kr
      notification.short_description_cn = short_noti_cn
      notification.category = 11
      if notification.save!
        if user.language == 'ja'
          send_notification_to_user(user.id, notification.title_ja, "mystery_jackpots", notification.source_id, notification.id, nil, notification.short_description_ja)
        elsif user.language == 'ko'
          send_notification_to_user(user.id, notification.title_kr, "mystery_jackpots", notification.source_id, notification.id, nil, notification.short_description_kr)
        elsif user.language == 'zh'
          send_notification_to_user(user.id, notification.title_cn, "mystery_jackpots", notification.source_id, notification.id, nil, notification.short_description_cn)
        else
          send_notification_to_user(user.id, notification.title, "mystery_jackpots", notification.source_id, notification.id, nil, notification.short_description)
        end
      end
    end
    user_web = User.select('users.id, devices.token').joins(:devices => []).where("devices.device_type = 'web'").uniq
    user_web.each do |user|
      notification = Notification.new
      notification.user_id = user.id
      notification.source_id = myjp_send.id
      notification.source_type = "mystery_jackpots"
      notification.notification_type = 11
      notification.status = 1
      notification.status_type = 1
      notification.title = title_noti
      notification.title_ja = title_noti
      notification.title_kr = title_noti
      notification.title_cn = title_noti
      notification.content = content_noti
      notification.content_ja = content_noti
      notification.content_kr = content_noti
      notification.content_cn = content_noti
      notification.short_description = short_noti
      notification.short_description_ja = short_noti
      notification.short_description_kr = short_noti
      notification.short_description_cn = short_noti
      notification.category = 11
      if notification.save
        send_notification_to_user_web("Mystery Jackpot", notification.content, "mystery_jackpots", notification.source_id, user.token)
      end
    end
  end

  
  def get_content_from_url_neon_mystery_jackpot(_url, _method, _payload = nil)
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
      alert_mystery_jackpot_from_request(_url)
      result.set_error_data(:service_unavailable, I18n.t('messages.can_not_connect_to_server'))
    rescue StandardError => e
      alert_mystery_jackpot_from_request(_url)
      result.set_error_data(:service_unavailable, I18n.t('messages.can_not_connect_to_server') + hostname)
    end
    return result
  end
end