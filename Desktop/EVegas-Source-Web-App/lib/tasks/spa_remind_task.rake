namespace :spa_remind_task do
    desc 'spa mc'
    task :remind_spa_finish => [ :environment ] do
        # include NotificationModule
        # time_now = Time.zone.now
        # setting = Setting.where('setting_key = ?', 'TIME_SPA_AND_ACCOMMODATION_REMINDER').first()
        # remind_noti =  JSON.parse(Setting.where('setting_key = ?', 'BOOKING_FINISH_NOTIFICATION_CONFIG').first().setting_value)
        # time_reminder = setting ? setting['setting_value'].to_i : 30
        # combined_datetime = "TIMESTAMP(spas.date_pick, spas.time_pick)"
        # spa = Spa.where("#{combined_datetime} >= ? AND status > 0", time_now).order("#{combined_datetime} ASC").limit(100)
        # setting = Setting.where('setting_key = ?', 'TITLE_APP_NOTIFICATION').first()
        # noti_title = "E-VG Caravelle"
        # if setting != nil
        #   noti_title = setting.setting_value
        # end

        # spa.each do |item|
        #     time_noti = ((item[:time_pick].to_time.to_i - time_now.to_i)/60).round
            # puts item.to_json
            # if(time_noti == time_reminder)
                # user = User.select('users.*').joins(:customer).where('customers.id = ?', item[:customer_id].to_i).first
                # if !user.nil?
                #     notification = Notification.new
                #     notification.user_id = user[:id]
                #     notification.source_id = item[:id]
                #     notification.source_type = "spas"
                #     notification.notification_type = 7
                #     notification.status_type = 3
                #     notification.status = 1
                    
                #     notification.title = noti_title
                #     notification.title_ja = noti_title
                #     notification.title_kr = noti_title
                #     notification.title_cn = noti_title
                #     notification.content = remind_noti['message']
                #     notification.content_ja = remind_noti['message_ja']
                #     notification.content_kr = remind_noti['message_ko']
                #     notification.content_cn = remind_noti['message_zh']
                #     notification.short_description = remind_noti['message']
                #     notification.short_description_ja = remind_noti['message_ja']
                #     notification.short_description_kr = remind_noti['message_ko']
                #     notification.short_description_cn = remind_noti['message_zh']

                #     if notification.save
                #         if user.language == 'ja'
                #             send_notification_to_user(user.id, noti_title, notification.source_type, notification.source_id, notification.id, message.attachment_id, notification.short_description_ja)
                #         elsif user.language == 'ko'
                #             send_notification_to_user(user.id, noti_title, notification.source_type, notification.source_id, notification.id, message.attachment_id, notification.short_description_kr)
                #         elsif user.language == 'zh'
                #             send_notification_to_user(user.id, noti_title, notification.source_type, notification.source_id, notification.id, message.attachment_id, notification.short_description_cn)
                #         else
                #             send_notification_to_user(user.id, noti_title, notification.source_type, notification.source_id, notification.id, message.attachment_id, notification.short_description)
                #         end
                #     end
                # end
            #     item.status = 3
            #     item.save
            # end
        # end
    end
end