
namespace :sync_jackpot_machine_task do
    desc 'sync jackpot machine'
    task :sync_jp_machine => [ :environment ] do
        include JackpotMachineModule
        get_data_jackpot_machine_from_neon()
    end
end
