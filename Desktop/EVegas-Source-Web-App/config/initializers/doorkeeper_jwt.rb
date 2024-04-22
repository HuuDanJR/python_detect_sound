# frozen_string_literal: true
include CustomerModule
include CommonModule

Doorkeeper::JWT.configure do
    # Set the payload for the JWT token. This should contain unique information
    # about the user. Defaults to a randomly generated token in a hash:
    #     { token: "RANDOM-TOKEN" }
    token_payload do |opts|
      user = User.find(opts[:resource_owner_id])
      customer_id = 0
      officer_id = 0
      if !user.customer.nil?
        customer_id = user.customer.id
      end
      if customer_id == 0
        officer = Officer.where('user_id = ?', user.id.to_i).first
        if !officer.nil?
          officer.online = 1
          officer.save!
          officer_id = officer.id
        end
      else
        user_member = User.select('users.*, customers.membership_type_name, customers.number').joins(:customer).where('users.id = ? AND customers.membership_type_name = ?', user.id.to_i, "SUSPENDED").first
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
        customer = Customer.find_by user_id: user.id
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
                user = User.find_by id: user.id
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
      end
  
      {
        iss: 'VCMS App',
        iat: Time.current.utc.to_i,
  
        # @see JWT reserved claims - https://tools.ietf.org/html/draft-jones-json-web-token-07#page-7
        jti: SecureRandom.uuid,
  
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          customer_id: customer_id.to_i,
          officer_id: officer_id.to_i
        }
      }
    end
  
    # Optionally set additional headers for the JWT. See
    # https://tools.ietf.org/html/rfc7515#section-4.1
    token_headers do |opts|
      { kid: opts[:application][:uid] }
    end
  
    # Use the application secret specified in the access grant token. Defaults to
    # `false`. If you specify `use_application_secret true`, both `secret_key` and
    # `secret_key_path` will be ignored.
    use_application_secret false
  
    # Set the encryption secret. This would be shared with any other applications
    # that should be able to read the payload of the token. Defaults to "secret".
    secret_key ENV['DOORKEEPER_JWT_SECRET']
  
    # If you want to use RS* encoding specify the path to the RSA key to use for
    # signing. If you specify a `secret_key_path` it will be used instead of
    # `secret_key`.
    # secret_key_path File.join('path', 'to', 'file.pem')
  
    # Specify encryption type (https://github.com/progrium/ruby-jwt). Defaults to
    # `nil`.
    encryption_method :hs512
  end