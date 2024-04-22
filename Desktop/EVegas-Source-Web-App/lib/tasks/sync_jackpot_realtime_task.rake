
namespace :sync_jackpot_realtime_task do
    desc 'sync jackpot realtime'
    task :sync_jp_realtime => [ :environment ] do
        include JackpotMachineModule
        sync_data_jp_real_time()
    end
end
