
namespace :sync_customer_task do
    desc 'sync customer mc'
    task :sync_customer_by_day => [ :environment ] do
        include CustomerModule
        get_data_customer_by_date()
    end
end
