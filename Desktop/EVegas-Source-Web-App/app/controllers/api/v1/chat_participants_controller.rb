class Api::V1::ChatParticipantsController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [] # Requires access token for all actions
  before_action :authenticate_user!, only: [:show, :index]

  include ChatParticipantModule

  def initialize()
    super(CHAT_PARTICIPANT_ATTRIBUTE)
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