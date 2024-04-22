
namespace :sync_frame_point_task do
    desc 'sync frame point task'
    task :sync_frame_point => [ :environment ] do
        include CustomerModule
        synchronize_frame_data()
    end
end
