class Api::V1::NotificationsController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index, :show, :create, :update, :update_status, :get_count_notification_has_read, :update_read]
  before_action :check_request_body, only: [:update_status, :update_read]
  include NotificationModule

  def initialize()
    super(NOTIFICATION_ATTRIBUTE)
  end

  # GET /objects
  def index
    # Get cache data
    cache_key = redis_cache_generate_key_get_all(self.class_attribute.filter_params, self.class_attribute.clazz, __method__)
    cache_data = redis_cache_get(cache_key)
    if !(cache_data.nil?)
      render_success_json(SuccessData.new(:ok, JSON.parse(cache_data)), self.class_attribute.index_except_params, attach_data_param_include(params['include'], self.class_attribute.include_object_params))
      return
    end

    result = check_validate_get_all(self.class_attribute.clazz, self.class_attribute.include_object_params, params)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    result = get_all_object_override(self.class_attribute.clazz, self.class_attribute.filter_params, params)
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

    result = get_object_by_id(self.class_attribute.clazz, params[:id], params)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end
    
    result = update_is_read(params[:id])
    render_success_json(SuccessData.new(result.status, result.data), self.class_attribute.show_except_params, attach_data_param_include(params['include'], self.class_attribute.include_object_params), cache_key)
  end

  def get_notification_by_id
    notification_id = params[:id]
    result = validate_get_notification_id(notification_id)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end
    result = get_data_notification_customer_by_id(notification_id)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

  def update_status
    result = check_request_status(@request_body)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    result = update_status_notifcation(@request_body, @notification)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

  def get_count_notification_has_read
    user_id = params[:user_id]

    result = get_data_count_notification_has_read(user_id)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

  def update_read
    result = ResultHandler.new
    result = check_request_read(@request_body, current_user.id)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    result = update_read_by_id(@request_body)
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end

end