module LogMailModule
  include CommonModule
  include DaoModule

  LOG_MAIL_ATTRIBUTE = ClassAttribute.new
  LOG_MAIL_ATTRIBUTE.clazz = LogMail
  LOG_MAIL_ATTRIBUTE.object_key = "log_mails"
  LOG_MAIL_ATTRIBUTE.filter_params = ["search", "by_customer"]
  
  def alert_jp_realtime
    time_now = Time.zone.now
    jjbx_data = JackpotRealTime.last
    if jjbx_data != nil
      setting_config = Setting.where('setting_key = ?', 'NEON_JACKPOT_GATEWAY').first!.setting_value
      time_alert = ((time_now.to_i - jjbx_data.created_at.to_time.to_i)/60).round
      data_tmp = eval(jjbx_data.data.as_json)
      last_logmail_no_data = LogMail.where("log_type = 'jackpot_real_times' AND created_at between ? AND ? AND log_type_send = 0", time_now.beginning_of_day, time_now.end_of_day).last
      if time_alert > 10
        if last_logmail_no_data == nil
          mail_to = Setting.where('setting_key = ?', 'EMAIL_ALERT_CONFIG').first().setting_value.to_s
          mail_subject = "E-Vegas - Alert Jackpot realtime NEON - " + time_now.strftime("%Y-%m-%d")
          mail_body = '<br/>Thông báo <b>không nhận được dữ liệu mới nhất</b>'
          mail_body += '<br/>Dữ liệu cuối cùng được cập nhật vào lúc ' + jjbx_data.created_at.strftime("%Y-%m-%d %T")
          mail_body += '<br/>Đường dẫn lấy dữ liệu: ' + setting_config.to_s
          mail_body += '<br/>Dữ liệu: <ul>'
          data_tmp[:data].each do |item|
            mail_body += '<li>Name: '+ item[:name].to_s + ' --- ' + 'Value: ' + item[:value].to_s + '</li>'
          end
          mail_body += '</ul>'
          mail_body += '<br/>'
          mail_body += '<br/>Best Regards,'

          log_mail = LogMail.new
          log_mail.email = mail_to
          log_mail.content = mail_body
          log_mail.log_type = "jackpot_real_times"
          log_mail.log_type_send = false
          log_mail.created_at = time_now
          log_mail.updated_at = time_now
          log_mail.save

          SystemMailer.send_email(mail_to, mail_subject, mail_body).deliver_now
        end
      else
        if last_logmail_no_data != nil
          last_logmail = LogMail.where("log_type = 'jackpot_real_times' AND created_at between ? AND ? AND log_type_send = 1", time_now.beginning_of_day, time_now.end_of_day).last
          if last_logmail == nil
            mail_to = Setting.where('setting_key = ?', 'EMAIL_ALERT_CONFIG').first().setting_value.to_s
            mail_subject = "E-Vegas - Alert Jackpot realtime NEON - " + time_now.strftime("%Y-%m-%d")
            mail_body = '<br/>Thông báo <b>nhận được dữ liệu mới nhất</b>'
            mail_body += '<br/>Dữ liệu cuối cùng được cập nhật vào lúc ' + jjbx_data.created_at.strftime("%Y-%m-%d %T")
            mail_body += '<br/>Đường dẫn lấy dữ liệu: ' + setting_config.to_s
            mail_body += '<br/>Dữ liệu: <ul>'
            data_tmp[:data].each do |item|
              mail_body += '<li>Name: '+ item[:name].to_s + ' --- ' + 'Value: ' + item[:value].to_s + '</li>'
            end
            mail_body += '</ul>'
            mail_body += '<br/>'
            mail_body += '<br/>Best Regards,'

            log_mail = LogMail.new
            log_mail.email = mail_to
            log_mail.content = mail_body
            log_mail.log_type = "jackpot_real_times"
            log_mail.log_type_send = true
            log_mail.created_at = time_now
            log_mail.updated_at = time_now
            log_mail.save

            SystemMailer.send_email(mail_to, mail_subject, mail_body).deliver_now
          end
        end
      end
    end
  end

  def alert_jjbx
    time_now = Time.zone.now
    item = JjbxMachine.last
    if item != nil
      time_alert = ((time_now.to_i - item.created_at.to_time.to_i)/60).round
      last_logmail_no_data = LogMail.where("log_type = 'jjbx_machines' AND created_at between ? AND ? AND log_type_send = 0", time_now.beginning_of_day, time_now.end_of_day).last
      if time_alert > 10
        if last_logmail_no_data == nil
          mail_to = Setting.where('setting_key = ?', 'EMAIL_ALERT_CONFIG').first().setting_value.to_s
          mail_subject = "E-Vegas - Alert JJBX OCR - " + time_now.strftime("%Y-%m-%d")
          mail_body = '<br/>Thông báo <b>không nhận được dữ liệu mới nhất</b>'
          mail_body += '<br/>Dữ liệu cuối cùng được cập nhật vào lúc ' + item.created_at.strftime("%Y-%m-%d %T")
          mail_body += '<br/>Dữ liệu: Grand name: ' + item.grand_value.to_s + ' -- Major value: ' + item.major_value.to_s
          mail_body += '<br/>Đường dẫn lấy dữ liệu: Dữ liệu lấy từ OCR'
          mail_body += '<br/>'
          mail_body += '<br/>Best Regards,'

          log_mail = LogMail.new
          log_mail.email = mail_to
          log_mail.content = mail_body
          log_mail.log_type = "jjbx_machines"
          log_mail.log_type_send = false
          log_mail.created_at = time_now
          log_mail.updated_at = time_now
          log_mail.save

          SystemMailer.send_email(mail_to, mail_subject, mail_body).deliver_now
        end
      else
        if last_logmail_no_data != nil
          last_logmail = LogMail.where("log_type = 'jjbx_machines' AND created_at between ? AND ? AND log_type_send = 1", time_now.beginning_of_day, time_now.end_of_day).last
          if last_logmail == nil
            mail_to = Setting.where('setting_key = ?', 'EMAIL_ALERT_CONFIG').first().setting_value.to_s
            mail_subject = "E-Vegas - Alert JJBX OCR - " + time_now.strftime("%Y-%m-%d")
            mail_body = '<br/>Thông báo <b>nhận được dữ liệu mới nhất</b>'
            mail_body += '<br/>Dữ liệu cuối cùng được cập nhật vào lúc ' + item.created_at.strftime("%Y-%m-%d %T")
            mail_body += '<br/>Dữ liệu: Grand name: ' + item.grand_value.to_s + ' -- Major value: ' + item.major_value.to_s
            mail_body += '<br/>Đường dẫn lấy dữ liệu: Dữ liệu lấy từ OCR'
            mail_body += '<br/>'
            mail_body += '<br/>Best Regards,'

            log_mail = LogMail.new
            log_mail.email = mail_to
            log_mail.content = mail_body
            log_mail.log_type = "jjbx_machines"
            log_mail.log_type_send = true
            log_mail.created_at = time_now
            log_mail.updated_at = time_now
            log_mail.save

            SystemMailer.send_email(mail_to, mail_subject, mail_body).deliver_now
          end
        end
      end
    end
  end

  def alert_mystery_jackpot
    time_now = Time.zone.now
    item = MysteryJackpot.last
    if item != nil
      setting_config = JSON.parse(Setting.where('setting_key = ?', 'MYSTERY_JACKPOT_NOTIFICATION').first!.setting_value)
      time_alert = ((time_now.to_i - jjbx_data.created_at.to_time.to_i)/60).round
      if time_alert > 10
        last_logmail = LogMail.where("log_type = 'mystery_jackpots' AND created_at between ? AND ? AND log_type_send = 0", time_now.beginning_of_day, time_now.end_of_day).last
        if last_logmail == nil
          mail_to = Setting.where('setting_key = ?', 'EMAIL_ALERT_CONFIG').first().setting_value.to_s
          mail_subject = "E-Vegas - Alert Mystery Jackpots - " + time_now.strftime("%Y-%m-%d")
          mail_body = '<br/>Thông báo <b>không nhận được dữ liệu mới nhất</b>'
          mail_body += '<br/>Dữ liệu cuối cùng được cập nhật vào lúc ' + item.created_at.strftime("%Y-%m-%d %T")
          mail_body += '<br/>Đường dẫn lấy dữ liệu: ' + setting_config.to_s
          mail_body += '<br/>Dữ liệu: ' + item.to_json
          mail_body += '<br/>'
          mail_body += '<br/>Best Regards,'

          log_mail = LogMail.new
          log_mail.email = mail_to
          log_mail.content = mail_body
          log_mail.log_type = "mystery_jackpots"
          log_mail.log_type_send = false
          log_mail.created_at = time_now
          log_mail.updated_at = time_now
          log_mail.save

          SystemMailer.send_email(mail_to, mail_subject, mail_body).deliver_now
        end
      else
        last_logmail = LogMail.where("log_type = 'mystery_jackpots' AND created_at between ? AND ? AND log_type_send = 1", time_now.beginning_of_day, time_now.end_of_day).last
        if last_logmail == nil
          mail_to = Setting.where('setting_key = ?', 'EMAIL_ALERT_CONFIG').first().setting_value.to_s
          mail_subject = "E-Vegas - Alert Mystery Jackpots - " + time_now.strftime("%Y-%m-%d")
          mail_body = '<br/>Thông báo <b>nhận được dữ liệu mới nhất</b>'
          mail_body += '<br/>Dữ liệu cuối cùng được cập nhật vào lúc ' + item.created_at.strftime("%Y-%m-%d %T")
          mail_body += '<br/>Đường dẫn lấy dữ liệu: ' + setting_config.to_s
          mail_body += '<br/>Dữ liệu: ' + item.to_json
          mail_body += '<br/>'
          mail_body += '<br/>Best Regards,'

          log_mail = LogMail.new
          log_mail.email = mail_to
          log_mail.content = mail_body
          log_mail.log_type = "mystery_jackpots"
          log_mail.log_type_send = true
          log_mail.created_at = time_now
          log_mail.updated_at = time_now
          log_mail.save

          SystemMailer.send_email(mail_to, mail_subject, mail_body).deliver_now
        end
      end
    end
  end

  def alert_mystery_jackpot_from_request(_url_request)
    item = MysteryJackpot.last
    mail_to = Setting.where('setting_key = ?', 'EMAIL_ALERT_CONFIG').first().setting_value.to_s
    mail_subject = "E-Vegas - Alert Jackpot Machine - " + time_now.strftime("%Y-%m-%d")
    mail_body = '<br/>Thông báo Serivce API Neon bị lỗi không lấy được dữ liệu (Màn hình Mystery Jackpot)'
    mail_body += '<br/>Dữ liệu cuối cùng được cập nhật vào lúc ' + item.created_at.strftime("%Y-%m-%d %T")
    mail_body += '<br/>Đường dẫn lấy dữ liệu: ' + _url_request.to_s
    mail_body += '<br/>Dữ liệu: ' + item.to_json
    mail_body += '<br/>'
    mail_body += '<br/>Best Regards,'

    log_mail = LogMail.new
    log_mail.email = mail_to
    log_mail.content = mail_body
    log_mail.log_type = "mystery_jackpots"
    log_mail.log_type_send = false
    log_mail.created_at = time_now
    log_mail.updated_at = time_now
    log_mail.save

    SystemMailer.send_email(mail_to, mail_subject, mail_body).deliver_now
  end

  def alert_jackpot_machines(_url_request)
    item = JackpotMachine.last
    mail_to = Setting.where('setting_key = ?', 'EMAIL_ALERT_CONFIG').first().setting_value.to_s
    mail_subject = "E-Vegas - Alert Jackpot Machine - " + time_now.strftime("%Y-%m-%d")
    mail_body = '<br/>Thông báo Serivce API Neon bị lỗi không lấy được dữ liệu (Màn hình Jackpot)'
    mail_body += '<br/>Dữ liệu cuối cùng được cập nhật vào lúc ' + item.created_at.strftime("%Y-%m-%d %T")
    mail_body += '<br/>Đường dẫn lấy dữ liệu: ' + _url_request.to_s
    mail_body += '<br/>Dữ liệu: ' + item.to_json
    mail_body += '<br/>'
    mail_body += '<br/>Best Regards,'

    log_mail = LogMail.new
    log_mail.email = mail_to
    log_mail.content = mail_body
    log_mail.log_type = "jackpot_machines"
    log_mail.log_type_send = false
    log_mail.created_at = time_now
    log_mail.updated_at = time_now
    log_mail.save

    SystemMailer.send_email(mail_to, mail_subject, mail_body).deliver_now
  end
  
  
  def alert_jackpot_machines_detail(_url_request)
    mail_to = Setting.where('setting_key = ?', 'EMAIL_ALERT_CONFIG').first().setting_value.to_s
    mail_subject = "E-Vegas - Alert Jackpot Machine Detail - " + time_now.strftime("%Y-%m-%d")
    mail_body = '<br/>Thông báo Serivce API Neon bị lỗi không lấy được dữ liệu (Màn hình Slide)'
    mail_body += '<br/>Đường dẫn lấy dữ liệu: ' + _url_request.to_s
    mail_body += '<br/>'
    mail_body += '<br/>Best Regards,'

    log_mail = LogMail.new
    log_mail.email = mail_to
    log_mail.content = mail_body
    log_mail.log_type = "jackpot_machines_detail"
    log_mail.log_type_send = false
    log_mail.created_at = time_now
    log_mail.updated_at = time_now
    log_mail.save

    SystemMailer.send_email(mail_to, mail_subject, mail_body).deliver_now
  end

end