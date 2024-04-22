class Api::V1::CouponsController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index, :show]

  include CouponModule

  def initialize()
    super(COUPON_ATTRIBUTE)
  end

  # GET /objects
  def index
    # Get cache data
    setting_enable_cache = Setting.where('setting_key = ?', 'SETTING_ENABLE_CACHE_REQUEST_COUPON').first().setting_value.to_i
    cache_key = redis_cache_generate_key_get_all(self.class_attribute.filter_params, self.class_attribute.clazz, __method__)
    cache_data = redis_cache_get(cache_key)
    if setting_enable_cache.to_i == 1
      puts "Enable Cache"
      setting_time = Setting.where('setting_key = ?', 'SETTING_TIME_CALL_REQUEST_COUPON').first().setting_value.to_i
      time_now = Time.zone.now.to_i
      if(params.has_key?(:sort))
        if params[:sort] == 'expired'
          cache_key_coupon = cache_data_coupon(current_user.id, self.class_attribute.filter_params)
          cache_action = redis_cache_get_coupon(cache_key_coupon)
          if cache_action.present?
            # sleep(1)
            set_key_coupon(cache_key_coupon, time_now)
            if (time_now- cache_action.to_i) <= setting_time.to_i
              render_success_json(SuccessData.new(:ok, []), self.class_attribute.index_except_params, attach_data_param_include(params['include'], self.class_attribute.include_object_params))
              return
            end
          else
            set_key_coupon(cache_key_coupon, time_now)
          end
        end
      end
    end

    if !(cache_data.nil?)
      render_success_json(SuccessData.new(:ok, JSON.parse(cache_data)), self.class_attribute.index_except_params, attach_data_param_include(params['include'], self.class_attribute.include_object_params))
      return
    end

    result = check_validate_get_all(self.class_attribute.clazz, self.class_attribute.include_object_params, params)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    result = get_all_object(self.class_attribute.clazz, self.class_attribute.filter_params, params)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data), self.class_attribute.index_except_params, attach_data_param_include(params['include'], self.class_attribute.include_object_params), cache_key)
  end
  
  # GET /objects/:id
  def show
    # Get cache data
    cache_key = redis_cache_generate_key_get_by_id(self.class_attribute.clazz, __method__)
    cache_data = redis_cache_get(cache_key)
    if !(cache_data.nil?)
      render_success_json(SuccessData.new(:ok, JSON.parse(cache_data)), self.class_attribute.index_except_params, attach_data_param_include(params['include'], self.class_attribute.include_object_params))
      return
    end

    result = check_validate_get_by_id(self.class_attribute.clazz, self.class_attribute.include_object_params, params)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    result = get_object_by_id_override(self.class_attribute.clazz, params[:id], params)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data), self.class_attribute.show_except_params, attach_data_param_include(params['include'], self.class_attribute.include_object_params), cache_key)
  end

end