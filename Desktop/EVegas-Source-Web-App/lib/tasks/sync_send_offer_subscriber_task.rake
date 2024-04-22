
namespace :sync_send_offer_subscriber_task do
    desc 'sync user offer subscriber'
    task :sync_send_offer_subscriber => [ :environment ] do
        include NotificationModule
        syns_offer_subscriber_notification()
    end
end
