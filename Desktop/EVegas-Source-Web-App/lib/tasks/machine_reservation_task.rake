namespace :machine_reservation_task do
    desc 'notification mc'
    task :remind_customer_expires_mc => [ :environment ] do
        include NotificationModule
        time_now = Time.zone.now
        setting = Setting.where('setting_key = ?', 'TIME_MC_RESERVATION_REMINDER').first()
        remind_noti =  JSON.parse(Setting.where('setting_key = ?', 'MACHINE_RESERVATION_REMIND_CONFIG').first().setting_value)
        time_reminder = setting ? setting['setting_value'].to_i : 30
        machine_reservations = MachineReservation.where('ended_at >= ? AND status > 0', time_now).order('ended_at asc').limit(100)

        machine_reservations.each do |item|
            time_noti = ((item[:ended_at].to_time.to_i - time_now.to_i)/60).round
            if(time_noti == 1)
                user = User.select('users.*').joins(:customer).where('customers.id = ?', item[:customer_id].to_i).first
                if !user.nil?
                    notification = Notification.new
                    notification.user_id = user[:id]
                    notification.source_id = item[:id]
                    notification.source_type = "machine_reservations"
                    notification.notification_type = 3
                    notification.status_type = 3
                    notification.status = 1
                    notification.title = remind_noti['end']['title']
                    notification.title_ja = remind_noti['end']['title_ja']
                    notification.title_kr = remind_noti['end']['title_ko']
                    notification.title_cn = remind_noti['end']['title_zh']
                    notification.short_description = remind_noti['end']['description']
                    notification.short_description_ja = remind_noti['end']['description_ja']
                    notification.short_description_kr = remind_noti['end']['description_ko']
                    notification.short_description_cn = remind_noti['end']['description_zh']
                    notification.content = remind_noti['end']['message']
                    notification.content_ja = remind_noti['end']['message_ja']
                    notification.content_kr = remind_noti['end']['message_ko']
                    notification.content_cn = remind_noti['end']['message_zh']

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
                
                mc_item  = MachineReservation.where('id = ?', item[:id]).first
                if !mc_item.nil?
                    mc_item.status = 3
                    mc_item.save
                end
            end

            if(time_noti == time_reminder)
                user = User.select('users.*').joins(:customer).where('customers.id = ?', item[:customer_id].to_i).first
                if !user.nil?
                    notification = Notification.new
                    notification.user_id = user[:id]
                    notification.source_id = item[:id]
                    notification.source_type = "machine_reservations"
                    notification.notification_type = 3
                    notification.status_type = 2
                    notification.status = 1
                    notification.title = remind_noti['remind']['title']
                    notification.title_ja = remind_noti['remind']['title_ja']
                    notification.title_kr = remind_noti['remind']['title_ko']
                    notification.title_cn = remind_noti['remind']['title_zh']
                    notification.short_description = remind_noti['remind']['description']
                    notification.short_description_ja = remind_noti['remind']['description_ja']
                    notification.short_description_kr = remind_noti['remind']['description_ko']
                    notification.short_description_cn = remind_noti['remind']['description_zh']
                    notification.content = remind_noti['remind']['message']
                    notification.content_ja = remind_noti['remind']['message_ja']
                    notification.content_kr = remind_noti['remind']['message_ko']
                    notification.content_cn = remind_noti['remind']['message_zh']
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
        end
    end
end
