
namespace :data_sync_neon_task do
    desc 'data_sync_neon_task'
    task :alert_data_sync_neon => [ :environment ] do
        include LogMailModule
        alert_jp_realtime()
        alert_jjbx()
    end
end
