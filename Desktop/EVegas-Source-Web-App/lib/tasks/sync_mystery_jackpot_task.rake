
namespace :sync_mystery_jackpot_task do
    desc 'sync_mystery_jackpot_day'
    task sync_mystery_jackpot_day: :environment do
        include MysteryJackpotModule
        sync_mystery_jackpot()
    end
end
