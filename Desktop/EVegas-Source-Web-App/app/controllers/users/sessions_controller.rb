# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  
  include CustomerModule
  include CommonModule
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    @FireBaseConfig = FIREBASE_CONFIG
    @AppDomain =  HOST_NAME
    super
  end

  # POST /resource/sign_in
  def create
    user_member = User.select('users.*, customers.membership_type_name, customers.number').joins(:customer).where('users.email = ? AND customers.membership_type_name = ?', params[:user][:email].to_s, "SUSPENDED").first
    if user_member
      customer_neon = get_customer_by_number(user_member.number)
      if customer_neon[:membership_type_name] != "SUSPENDED"
        # user_member.unlock_access!
        user = User.find_by id: user_member.id
        if !user.nil?
          # user.locked_at = Time.now.utc
          # user.unlock_access!
        end

      end
    end
    super
    officer = Officer.find_by user_id: current_user.id
    if officer
      officer.online = 1
      officer.save!
    end
    customer = Customer.find_by user_id: current_user.id
    if customer && (customer.forename != 'Vegas01' )
      item = get_customer_by_number(customer.number)
      if !item.nil?
        customer.age = item[:age]
        customer.card_number = item[:card_number]
        customer.cashless_balance = item[:cashless_balance]
        customer.colour = item[:colour]
        customer.colour_html = item[:colour_html]
        customer.comp_balance = item[:comp_balance]
        customer.comp_status_colour = item[:comp_status_colour]
        customer.comp_status_colour_html = item[:comp_status_colour_html]
        customer.forename = item[:forename]
        customer.freeplay_balance = item[:freeplay_balance]
        customer.gender = item[:gender]
        customer.has_online_account = item[:has_online_account]
        customer.hide_comp_balance = item[:hide_comp_balance]
        customer.is_guest = item[:is_guest]
        customer.loyalty_balance = item[:loyalty_balance]
        customer.loyalty_points_available = item[:loyalty_points_available]
        customer.membership_type_name = item[:membership_type_name]
        customer.middle_name = item[:middle_name]
        customer.number = item[:number]
        customer.player_tier_name = item[:player_tier_name]
        customer.player_tier_short_code = item[:player_tier_short_code]
        customer.premium_player = item[:premium_player]
        customer.surname = item[:surname]
        customer.title = item[:title]
        customer.valid_membership = item[:valid_membership]
        _ok = customer.save

        if customer.membership_type_name.upcase == "SUSPENDED"
          if _ok
            user = User.find_by id: current_user.id
            if !user.nil?
              # user.locked_at = Time.now.utc
              # user.lock_access!({send_instructions: false}) 
            end
          else
            logger.debug "update customer number fail: #{customer.number}"
            raise ActiveRecord::Rollback, result = false unless _ok
          end 
  
        end

      end
    end
    
    $token_web = params[:token_web].to_s
    if params[:token_web].to_s.strip.empty? != true
      if customer.nil?
        device = Device.where(device_type: 'web', token: $token_web)
        if device
          device.destroy_all
        end
        device = Device.new
        device.token = $token_web
        device.device_type = 'web'
        device.user_id = current_user.id
        device.time_expired = 7.days.from_now
        device.save!
      end
    end
    Rails.application.routes.recognize_path "/dashboard"
  end

  # DELETE /resource/sign_out
  def destroy
    officer = Officer.find_by user_id: current_user.id
    if officer
      if officer.name != "Reception"
        officer.online = 0
        officer.save!
      end
    end
    current_user.invalidate_all_sessions!
    super
    device = Device.where(device_type: 'web', token: $token_web)
    if device
      device.destroy_all
    end
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
