
namespace :sync_notification_mystery_jackpot_task do
    desc 'sync_notification_mystery_jackpot_task'
    task sync_notification_mystery_jackpot: :environment do
        include MysteryJackpotModule
        send_notification_mystery_jackpot()
    end
end
