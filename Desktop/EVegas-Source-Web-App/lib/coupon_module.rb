module CouponModule
  include CommonModule
  include DaoModule

  COUPON_ATTRIBUTE = ClassAttribute.new
  COUPON_ATTRIBUTE.clazz = Coupon
  COUPON_ATTRIBUTE.object_key = "coupon"
  COUPON_ATTRIBUTE.filter_params = ["search", "by_customer", "by_expired", "by_time_start"]
  COUPON_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  COUPON_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  COUPON_ATTRIBUTE.include_object_params = {
    "benefits" => ["id", "name", "attachment_id", "description"],
    "coupon_benefits" => ["id", "benefit_id", "count_usage", "total_usage", "created_at", "updated_at"]
  }

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
        records.each do |record|
          coupon_template = CouponTemplate.where("id = ?", record.coupon_template_id).first
          if coupon_template != nil
            if coupon_template.description_ja.present? && user.language.to_s == 'ja'
              record.description = coupon_template.description_ja
            elsif coupon_template.description_kr.present? && user.language.to_s == 'ko'
              record.description = coupon_template.description_kr
            elsif coupon_template.description_cn.present? && user.language.to_s == 'zh'
              record.description = coupon_template.description_cn
            else
              record.description = coupon_template.description
            end
            if coupon_template.name_ja.present? && user.language.to_s == 'ja'
              record.name = coupon_template.name_ja
            elsif coupon_template.name_kr.present? && user.language.to_s == 'ko'
              record.name = coupon_template.name_kr
            elsif coupon_template.name_cn.present? && user.language.to_s == 'zh'
              record.name = coupon_template.name_cn
            else
              record.name = coupon_template.name
            end
          else
            if record.description_ja.present? && user.language.to_s == 'ja'
              record.description = record.description_ja
            elsif record.description_kr.present? && user.language.to_s == 'ko'
              record.description = record.description_kr
            elsif record.description_cn.present? && user.language.to_s == 'zh'
              record.description = record.description_cn
            else
              record.description = record.description
            end
            
            if record.name_ja.present? && user.language.to_s == 'ja'
              record.name = record.name_ja
            elsif record.name_kr.present? && user.language.to_s == 'ko'
              record.name = record.name_kr
            elsif record.name_cn.present? && user.language.to_s == 'zh'
              record.name = record.name_cn
            else
              record.name = record.name
            end

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

  # Get a object by id
  def get_object_by_id_override(clazz, id, input_params = nil)
    query_select = nil
    query_include = []

    if !input_params.nil?
      query_select = return_data_param_field(input_params['fields'])
      query_include = return_data_param_include(input_params['include'])
    end

    return get_object_by_id_abstract_override(clazz, id, query_select, query_include)
  end

  def get_object_by_id_abstract_override(clazz, id, select_params = nil, query_include = [])
    result = ResultHandler.new

    # Get query data
    query_select = '*'
    if !select_params.nil?
      query_select = select_params
    end

    logger.debug "Get object by id: #{clazz} - #{id}"
    logger.debug "Query select: #{query_select}"
    begin
      record = clazz.select(query_select)
      if record.nil?
        result.set_error_data(:not_found, I18n.t('messages.object_not_found'))
      else
        query_include.each do |item|
          record = record.includes(item)
        end
        record = record.find(id)
        data_tmp = record
        if record !=  nil
          user = User.select('language').find(current_user.id)
          coupon_template = CouponTemplate.where("id = ?", record.coupon_template_id).first
          if coupon_template != nil
            if coupon_template.description_ja.present? && user.language.to_s == 'ja'
              record.description = coupon_template.description_ja
            elsif coupon_template.description_kr.present? && user.language.to_s == 'ko'
              record.description = coupon_template.description_kr
            elsif coupon_template.description_cn.present? && user.language.to_s == 'zh'
              record.description = coupon_template.description_cn
            else
              record.description = coupon_template.description
            end
            if coupon_template.name_ja.present? && user.language.to_s == 'ja'
              record.name = coupon_template.name_ja
            elsif coupon_template.name_kr.present? && user.language.to_s == 'ko'
              record.name = coupon_template.name_kr
            elsif coupon_template.name_cn.present? && user.language.to_s == 'zh'
              record.name = coupon_template.name_cn
            else
              record.name = coupon_template.name
            end
          else
            if record.description_ja.present? && user.language.to_s == 'ja'
              record.description = record.description_ja
            elsif record.description_kr.present? && user.language.to_s == 'ko'
              record.description = record.description_kr
            elsif record.description_cn.present? && user.language.to_s == 'zh'
              record.description = record.description_cn
            else
              record.description = record.description
            end
            
            if record.name_ja.present? && user.language.to_s == 'ja'
              record.name = record.name_ja
            elsif record.name_kr.present? && user.language.to_s == 'ko'
              record.name = record.name_kr
            elsif record.name_cn.present? && user.language.to_s == 'zh'
              record.name = record.name_cn
            else
              record.name = record.name
            end

          end
        end

        result.set_success_data(:ok, data_tmp)
      end
    rescue ActiveRecord::StatementInvalid => e
      result.set_error_data(:internal_server_error, e.to_s)
    rescue StandardError => e
      if e.to_s.include? "Couldn't find"
        result.set_error_data(:not_found, e.to_s)
      else
        result.set_error_data(:internal_server_error, e.to_s)
      end
    end

    return result
  end

end