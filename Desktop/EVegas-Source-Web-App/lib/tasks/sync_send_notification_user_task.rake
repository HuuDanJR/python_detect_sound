
namespace :sync_send_notification_user_task do
    desc 'sync user token expired'
    task :sync_send_notification_user => [ :environment ] do
        include NotificationModule
        syns_notification()
    end
end
