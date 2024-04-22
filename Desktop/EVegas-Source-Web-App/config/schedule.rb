# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end
ENV.each_key do |key|
    env key.to_sym, ENV[key]
end

set :environment, ENV["RAILS_ENV"]

set :output, "log/cron_log.log"
#set :bundle_command, "/usr/local/bin/bundle exec"
# Learn more: http://github.com/javan/whenever
every 1.minute do
    rake 'machine_reservation_task:remind_customer_expires_mc'
    rake 'sync_send_notification_user_task:sync_send_notification_user'
    # rake 'sync_send_offer_subscriber_task:sync_send_offer_subscriber'
    # rake 'spa_remind_task:remind_spa_finish'
    # rake 'accommodation_remind_task:remind_accommodation_finish'
end

every 2.minute do
    rake 'sync_jackpot_machine_task:sync_jp_machine'
end

every 5.minute do
    rake "sync_notification_mystery_jackpot_task:sync_notification_mystery_jackpot"
    rake "sync_mystery_jackpot_task:sync_mystery_jackpot_day"
end

every 10.minute do
    rake "data_sync_neon_task:alert_data_sync_neon"
end

every 1.day, at: ['4:00 am', '8:00 am' , '12:00 am', '4:00 pm', '8:00 pm', '12:00 pm'] do
    rake 'sync_customer_task:sync_customer_by_day'
end

# every 1.day, at: ['3:00 am'] do
#     rake 'sync_delete_notification_task:sync_update_delete_notification'
# end

# every 1.day, at: ['3:00 am'] do
#     rake 'sync_token_user_task:sync_token_expired'
# end

every 1.day, at: ['11:00 am', '11:30 am'] do
    rake 'sync_frame_point_task:sync_frame_point'
end

# every 1.minute do
#     rake 'sync_jackpot_realtime_task:sync_jp_realtime'
# end