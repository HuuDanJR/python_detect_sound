Rails.application.routes.draw do
  devise_for :user, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords',
      confirmations: 'users/confirmations',
      unlocks: 'users/unlocks',
      omniauth_callbacks: 'users/omniauth_callbacks'
  }
  get '/404', to: 'application#redirect_to_not_found'
  get '/422', to: 'application#redirect_to_unprocessable'
  get '/500', to: 'application#redirect_to_500_error'
  get 'admin' => redirect('/dashboard')
  get 'dashboard', to: 'dashboard#index'
  get 'home', to: 'home#index'
  get '/home/product', to: 'home#product'
  get '/home/privacy', to: 'home#privacy'
  get '/home/staff', to: 'home#staff'
  get '/home/staff_introduce', to: 'home#staff_introduce'

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :attachments, only: [:download] do
        collection do
          get '/download/:id', to: 'attachments#download', constraints: {:id => /\d+/}
          post '/upload', to: 'attachments#upload'
        end
      end

      resources :carts, only: [:index, :create, :show, :update]

      resources :customers, only: [:index, :show] do
        collection do
          get '/get_customer_by_user_id/:id', to: 'customers#get_customer_by_user_id', constraints: {:id => /\d+/}
          get '/:id/point', to: 'customers#get_customer_point', constraints: {:id => /\d+/}
          get '/:id/voucher', to: 'customers#get_customer_voucher', constraints: {:id => /\d+/}
          get '/:id/jackpot_history', to: 'customers#get_customer_jackpot_history', constraints: {:id => /\d+/}
          get '/:id/machine', to: 'customers#get_customer_machine', constraints: {:id => /\d+/}
          get '/:id/delete_account', to: 'customers#lock_account_user', constraints: {:id => /\d+/}
          get '/:id/sign_out', to: 'customers#sign_out_by_user', constraints: {:id => /\d+/}
          post '/change_password', to: 'customers#change_password_customer'
          get ':id/update_avatar/:attachment_id', to: 'customers#update_avatar', constraints: {:id => /\d+/, :attachment_id => /\d+/}
          get '/:id/total_voucher', to: 'customers#get_customer_total_voucher', constraints: {:id => /\d+/}
          post '/update_language', to: 'customers#update_language'
          post '/update_setting', to: 'customers#update_setting'
          post '/update_phone', to: 'customers#update_phone'
        end
      end

      resources :devices, only: [:index, :create, :destroy] do
        collection do
          post '/destroy', to: 'devices#destroy'
        end
      end

      resources :memberships, only: [:index, :show]

      resources :officer_customers, only: [:index, :create]

      resources :officers, only: [:index, :show] do
        collection do
          get '/update_offline', to: 'officers#offline'
        end
      end

      resources :orders, only: [:index, :show, :create] do
        collection do
          #get '/product_order/:id', to: 'orders#get_product_order_by_order_id', constraints: {:id => /\d+/}
        end
      end
      
      resources :pyramid_points, only: [:index, :show]

      resources :reservations, only: [:index, :show, :create]

      resources :roulettes, only: [:index, :show]

      resources :settings, only: [:index, :show] do
        collection do
          get '/get_term_of_service', to: 'settings#get_term_of_service'
          get '/get_staff_note', to: 'settings#get_staff_note'
          get '/get_app_domain', to: 'settings#get_app_domain'
          get '/get_forgot_password_notification', to: 'settings#get_forgot_password'
        end
      end

      resources :machine_reservations, only: [:index, :show, :create, :update] do
        collection do
          get '/get_machine_from_neon/:number', to: 'machine_reservations#get_machine_reservation_neon', constraints: {:number => /\d+/}
          get '/get_machine_from_neon_active', to: 'machine_reservations#get_list_machine_active'
        end
      end

      resources :notifications, only: [:index, :show] do
        collection do
          post '/delete', to: 'notifications#update_status'
          get '/count/:user_id', to: 'notifications#get_count_notification_has_read', constraints: {:user_id => /\d+/}
          post '/update_read', to: 'notifications#update_read'
        end
      end

      resources :products, only: [:index, :show]

      resources :product_categories, only: [:index, :show]

      resources :promotions, only: [:index, :show]

      resources :jackpot_machines, only: [:index, :show] do
        collection do
          get '/get_jp_machines_by_date', to: 'jackpot_machines#get_jp_machines_by_date'
          get '/jp-real-time', to: 'jackpot_machines#get_jp_real_time'
          get '/sync_jp_real_time', to: 'jackpot_machines#sync_jp_realtime'
          get '/jp_real_time/:id', to: 'jackpot_machines#get_jp_real_time_detail'
          get '/jp_jjbx_detail', to: 'jackpot_machines#get_jjbx_detail'
        end
      end

      resources :messages, only: [:index, :show]

      
      resources :slides, only: [:index, :show]

      resources :coupons, only: [:index, :show]

      resources :benefits, only: [:index, :show]

      resources :jjbx_machines, only: [:index, :show, :create]

      resources :term_services, only: [:index, :show]

      resources :accommodations, only: [:index, :show, :create]
  
      resources :spas, only: [:index, :show, :create]
  
      resources :offers, only: [:index, :show]

      resources :offer_reactions, only: [:index, :show, :create, :update]

      resources :chat_messages, only: [:index, :show, :create] do
        collection do
          get '/update_read/:id', to: 'chat_messages#update_read_message', constraints: {:id => /\d+/}
        end
      end

      resources :chat_participants, only: [:index, :show, :create]

      resources :chat_rooms, only: [:create] do
        collection do
          get '/get_chat_room_by_user', to: 'chat_rooms#get_chat_room_by_user'
          post '/room_participant', to: 'chat_rooms#create_room_participant'
          get '/get_chat_room_by_host', to: 'chat_rooms#get_chat_room_by_host'
          get '/get_count_unread', to: 'chat_rooms#get_count_message_unread'
          get '/get_chat_user', to: 'chat_rooms#get_chat_room_for_user'
        end
      end
      
      resources :promotion_reactions, only: [:index, :show, :create, :update]

      resources :offer_subscribers, only: [:index, :show, :create, :update]
      
      resources :mystery_jackpots, only: [:index, :show]

      resources :promotion_subscribers, only: [:index, :show, :create, :update]
      
      resources :introductions, only: [:index, :show]
      
    end
  end

  resources :attachments do
    collection do
      get 'download/:id', to: 'attachments#download', constraints: {:id => /\d+/}
      get 'download-template-product', to: 'attachments#download_template_product'
      get 'download-template-customer', to: 'attachments#download_template_customer'
      get 'download-template-frame-date', to: 'attachments#download_template_frame_date'
      get 'download-template-customer-notification', to: 'attachments#download_template_notification'
    end
  end

  resources :customers do
    collection do
      get 'export', to: 'customers#export'
      get 'synchronize', to: 'customers#synchronize'
    end
  end

  resources :groups do
    collection do
      get ':id/edit_role', to: 'groups#edit_role', constraints: {:id => /\d+/}
      patch ':id/edit_role', to: 'groups#update_role', constraints: {:id => /\d+/}
    end
  end

  resources :machine_reservations do
    collection do
      get 'export', to: 'machine_reservations#export'
    end
  end

  resources :memberships do
    collection do
      get 'export', to: 'memberships#export'
    end
  end

  resources :messages do
    collection do
      get 'preview/:id', to: 'messages#preview', constraints: {:id => /\d+/}
      get 'copy_message/:id', to: 'messages#copy_message', constraints: {:id => /\d+/}
      post 'get_data_customers', to: 'messages#get_customers'
    end
  end

  resources :notifications do
     collection do
      get 'get_users', to: 'notifications#users_notification'
      get 'export', to: 'notifications#export'
      post 'user_by_list_number', to: 'notifications#user_by_numbers'
      get 'export_notification/:source_id', to: 'notifications#export_notification', constraints: {:source_id => /\d+/}
     end
  end

  resources :officer_customers do
    collection do
      get 'export', to: 'officer_customers#export'
    end
  end

  resources :officer_imports

  resources :officers do
    collection do
      get 'export', to: 'officers#export'
      get 'delete/:id/status/:status', to: 'officers#delete', constraints: {:id => /\d+/, :status => /\d+/}
      get 'active/:id/online/:online', to: 'officers#update_status_active', constraints: {:id => /\d+/}
    end
  end

  resources :orders do
    collection do
      get 'export', to: 'orders#export'
    end
  end

  resources :product_categories

  resources :product_imports

  resources :products

  resources :promotion_categories

  resources :promotions do
    collection do
      get ':id/subscribers', to: 'promotions#subscribers', constraints: {:id => /\d+/}
      get '/export/subscribers/:id', to: 'promotions#export_subscribers', constraints: {:id => /\d+/}
      get ':id/reactions', to: 'promotions#reactions', constraints: {:id => /\d+/}
      get '/export/reactions/:id', to: 'promotions#export_reactions', constraints: {:id => /\d+/}
    end
  end

  resources :pyramid_points do
    collection do
      get 'export', to: 'pyramid_points#export'
    end
  end

  resources :reservations do
    collection do
      get 'export', to: 'reservations#export'
      get ':id/update_status/:status', to: 'reservations#update_status', constraints: {:id => /\d+/, :status => /\d+/}
    end
  end

  resources :roles

  resources :roulettes do
    collection do
      get 'export', to: 'roulettes#export'
    end
  end

  resources :settings do
    collection do
      get 'mail', to: 'settings#edit_mail'
      post 'mail', to: 'settings#update_mail'
      get 'send-mail-testing', to: 'settings#send_email_testing'
    end
  end

  resources :users do
    collection do
      get ':id/activated', to: 'users#activate', constraints: {:id => /\d+/}
      get ':id/change-password', to: 'users#change_password', constraints: {:id => /\d+/}
      post ':id/change-password', to: 'users#execute_change_password', constraints: {:id => /\d+/}
      get ':id/reset-password', to: 'users#reset_password', constraints: {:id => /\d+/}
      get ':id/locked', to: 'users#lock', constraints: {:id => /\d+/}
      get ':id/unlocked', to: 'users#unlock', constraints: {:id => /\d+/}
      get 'latest_login', to: 'users#latest_login', constraints: {:id => /\d+/}
      get 'export', to: 'users#export'
    end
  end

  resources :drivers

  resources :customer_imports
  
  resources :jackpot_machines do
    collection do
      get 'export', to: 'jackpot_machines#export'
    end
  end
  
  resources :jackpot_game_types

  resources :customer_frame_date_imports

  resources :staff_imports

  resources :staff_introduces do
    collection do
      get 'export', to: 'staff_introduces#export'
    end
  end

  resources :user_first_logins do
    collection do
      get 'export', to: 'user_first_logins#export'
    end
  end

  resources :coupons do
    collection do
      get 'export', to: 'coupons#export'
      post 'used_benefit/:id', to: 'coupons#used_benefit'
      post 'undo_benefit/:id', to: 'coupons#undo_benefit'
      post 'update_note/:id', to: 'coupons#update_note_benefit'
    end
  end
  
  resources :benefits

  resources :staffs

  resources :slides

  resources :jackpot_real_times

  resources :term_services

  resources :accommodations
  
  resources :spas

  resources :offers do
    collection do
      get ':id/subscribers', to: 'offers#subscribers', constraints: {:id => /\d+/}
      get '/export/subscribers/:id', to: 'offers#export_subscribers', constraints: {:id => /\d+/}
      get ':id/reactions', to: 'offers#reactions', constraints: {:id => /\d+/}
      get '/export/reactions/:id', to: 'offers#export_reactions', constraints: {:id => /\d+/}
    end
  end

  
  resources :gamethemes

  resources :chat_rooms do
    collection do
      get 'get_chat_rooms', to: 'chat_rooms#chat_participants'
      get 'get_messages', to: 'chat_rooms#chat_messages'
      post 'create_messages', to: 'chat_rooms#create_messages'
      get 'send_messages', to: 'chat_rooms#send_messages'
      post 'upload_attachment_message', to: 'chat_rooms#upload_attachment_message'
    end
  end
  
  resources :logs do
    collection do
      get 'index', to: 'logs#index'
    end
  end

  resources :coupon_templates do
    collection do
      get 'get_name', to: 'coupon_templates#get_name_coupon'
    end
  end
  

  resources :introductions

  root to: 'home#index'
  use_doorkeeper_openid_connect
  use_doorkeeper
  match '*path', to: 'application#redirect_to_not_found', via: :all
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
