module BenefitModule
  include CommonModule
  include DaoModule

  BENEFIT_ATTRIBUTE = ClassAttribute.new
  BENEFIT_ATTRIBUTE.clazz = Benefit
  BENEFIT_ATTRIBUTE.object_key = "benefit"
  BENEFIT_ATTRIBUTE.filter_params = []
  BENEFIT_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  BENEFIT_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]

  # Get all object from database
  def get_all_object(clazz, clazz_filter_params, input_params, query = nil, order_field = nil)
    result = ResultHandler.new
    # Get query data
    query_select = return_data_param_field(input_params['fields'])
    query_order = return_data_param_order(input_params['sort'])
    query_limit = return_data_param_limit(input_params['limit'])
    query_offset = return_data_param_offset(input_params['offset'])
    query_include = return_data_param_include(input_params['include'])

    logger.debug "Get all object: #{clazz}"
    logger.debug "Input params: #{input_params}"
    begin
      records = clazz.filter(filtering_params(params, clazz_filter_params))
      # total = records.count
      query_include.each do |item|
        records = records.includes(item)
      end
      if !query.nil?
        records = records.where(query)
      end
      records = records.select(query_select)
                    .order(query_order)
                    .order(order_field)
                    .limit(query_limit)
                    .offset(query_offset)

      user = User.select('language').find(current_user.id)
      if records.length > 0
        records.each do |item|
          if item.name_ja.present? && user.language.to_s == 'ja'
            item.name =  item.name_ja
            item.description = item.description_ja
          elsif item.name_kr.present? && user.language.to_s == 'ko'
            item.name =  item.name_kr
            item.description = item.description_kr
          elsif item.name_cn.present? && user.language.to_s == 'zh'
            item.name =  item.name_cn
            item.description = item.description_cn
          else
            item.name =  item.name
            item.description = item.description
          end
        end
      end
      result.set_success_data(:ok, records)
    rescue ActiveRecord::StatementInvalid => e
      result.set_error_data(:internal_server_error, e.to_s)
    rescue StandardError => e
      result.set_error_data(:internal_server_error, e.to_s)
    end

    return result
  end

end