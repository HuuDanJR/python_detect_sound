
namespace :sync_token_user_task do
    desc 'sync user token expired'
    task :sync_token_expired => [ :environment ] do
        include DeviceModule
        syns_token_expired()
    end
end
