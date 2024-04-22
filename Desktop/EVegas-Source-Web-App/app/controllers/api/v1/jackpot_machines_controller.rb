class Api::V1::JackpotMachinesController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [:sync_jp_realtime, :get_jp_real_time_detail, :get_jjbx_detail] # Requires access token for all actions
  before_action :authenticate_user!, only: [:index, :show, :create, :update, :get_jp_machines_by_date, :get_jp_real_time]

  include JackpotMachineModule

  def initialize()
    super(JACKPOT_MACHINE_ATTRIBUTE)
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
  
  def get_jp_machines_by_date
    result = ResultHandler.new
    date_from = params['date_from']
    date_to = params['date_to']
    limit = params['limit'].to_i
    offset = params['offset'].to_i
    result = check_validate_date_from_and_date_to(date_from, date_to)
    if !result.result
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    result = get_data_jp_machine_by_date(date_from, date_to, limit, offset)
    if !result.result
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end
    render_success_json(SuccessData.new(result.status, result.data), nil, nil, nil)
  end

  def get_jp_real_time
    result = ResultHandler.new

    result = get_data_jp_real_time()
    if !result.result
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data), nil, nil, nil)
  end

  def sync_jp_realtime
    result = ResultHandler.new
    result = sync_data_jp_real_time()
    render_success_json(SuccessData.new(result.status, result.data), nil, nil, nil)
  end

  def get_jp_real_time_detail
    result = ResultHandler.new
    id = params['id']
    result = get_data_detail_jp_real_time(id)
    if !result.result
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data), nil, nil, nil)
  end

  def get_jjbx_detail
    result = ResultHandler.new
    level_jp = params['level'].to_i
    result = get_data_jjbx_detail(level_jp)
    if !result.result
      render_error_json(ErrorData.new(result.status, result.exception))
      return
    end

    render_success_json(SuccessData.new(result.status, result.data), nil, nil, nil)
  end

end