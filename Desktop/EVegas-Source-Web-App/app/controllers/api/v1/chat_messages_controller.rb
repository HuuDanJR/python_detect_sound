class Api::V1::ChatMessagesController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index, :show, :create, :update_read_message]

  include ChatMessageModule

  def initialize()
    super(CHAT_MESSAGE_ATTRIBUTE)
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

  def update_read_message
    result = ResultHandler.new
    result = update_read_message_by_id(current_user.id, params[:id])
    if result.result == false
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data))
  end
end