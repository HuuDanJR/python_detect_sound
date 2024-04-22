module OfferModule
  include CommonModule
  include DaoModule

  OFFER_ATTRIBUTE = ClassAttribute.new
  OFFER_ATTRIBUTE.clazz = Offer
  OFFER_ATTRIBUTE.object_key = "offer"
  OFFER_ATTRIBUTE.filter_params = ["by_is_highlight", "by_offer_type", "by_publish_date", "by_time_end"]
  OFFER_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  OFFER_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  OFFER_ATTRIBUTE.include_object_params = {
      "attachment" => ["id", "name", "category"],
      "offer_reactions" => ["id", "reaction_type", "user_id"]
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
      list_data = []
      user = User.select('language').find(current_user.id)
      if records.length > 0
        records.each do |item|
          if item.title_ja.present? && item.description_ja.present? && user.language.to_s == 'ja'
            list_data.push(Offer.new(id: item.id, title: item.title_ja, title_ja: item.title_ja, title_kr: item.title_ja, title_cn: item.title_ja, 
            description: item.description_ja, description_ja: item.description_ja, description_kr: item.description_ja, description_cn: item.description_ja,
            url_news: item.url_news, publish_date: item.publish_date, is_highlight: item.is_highlight, offer_type: item.offer_type, attachment_id: item.attachment_id, 
            created_at: item.created_at, updated_at: item.updated_at, time_end: item.time_end, index_order: item.index_order, is_discover: item.is_discover, banner_attachment: item.banner_attachment))
          elsif item.title_kr.present? && item.description_kr.present? && user.language.to_s == 'ko'
            list_data.push(Offer.new(id: item.id, title: item.title_kr, title_ja: item.title_kr, title_kr: item.title_kr, title_cn: item.title_kr,
            description: item.description_kr, description_ja: item.description_kr, description_kr: item.description_kr, description_cn: item.description_kr,
            url_news: item.url_news, publish_date: item.publish_date, is_highlight: item.is_highlight, offer_type: item.offer_type, attachment_id: item.attachment_id, 
            created_at: item.created_at, updated_at: item.updated_at, time_end: item.time_end, index_order: item.index_order, is_discover: item.is_discover, banner_attachment: item.banner_attachment))
          elsif item.title_cn.present? && item.description_cn.present? && user.language.to_s == 'zh'
            list_data.push(Offer.new(id: item.id, title: item.title_cn, title_ja: item.title_cn, title_kr: item.title_cn, title_cn: item.title_cn,
            description: item.description_cn, description_ja: item.description_cn, description_kr: item.description_cn, description_cn: item.description_cn, 
            url_news: item.url_news, publish_date: item.publish_date, is_highlight: item.is_highlight, offer_type: item.offer_type, attachment_id: item.attachment_id, 
            created_at: item.created_at, updated_at: item.updated_at, time_end: item.time_end, index_order: item.index_order, is_discover: item.is_discover, banner_attachment: item.banner_attachment))
          else
            list_data.push(Offer.new(id: item.id, title: item.title, title_ja: item.title, title_kr: item.title, title_cn: item.title,
            description: item.description, description_ja: item.description, description_kr: item.description, description_cn: item.description,
            url_news: item.url_news, publish_date: item.publish_date, is_highlight: item.is_highlight, offer_type: item.offer_type, attachment_id: item.attachment_id, 
            created_at: item.created_at, updated_at: item.updated_at, time_end: item.time_end, index_order: item.index_order, is_discover: item.is_discover, banner_attachment: item.banner_attachment))
          end
        end
      end
      result.set_success_data(:ok, list_data)
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
        user = User.select('language').find(current_user.id)
        if record.title_ja.present? && record.description_ja.present? && user.language.to_s == 'ja'
          data_tmp = Offer.new(id: record.id, title: record.title_ja, title_ja: record.title_ja, title_kr: record.title_ja, title_cn: record.title_ja, 
          description: record.description_ja, description_ja: record.description_ja, description_kr: record.description_ja, description_cn: record.description_ja,
          url_news: record.url_news, publish_date: record.publish_date, is_highlight: record.is_highlight, offer_type: record.offer_type, attachment_id: record.attachment_id, 
          created_at: record.created_at, updated_at: record.updated_at, time_end: record.time_end, index_order: record.index_order, is_discover: record.is_discover, banner_attachment: record.banner_attachment)
        elsif record.title_kr.present? && record.description_kr.present? && user.language.to_s == 'ko'
          data_tmp = Offer.new(id: record.id, title: record.title_kr, title_ja: record.title_kr, title_kr: record.title_kr, title_cn: record.title_kr,
          description: record.description_kr, description_ja: record.description_kr, description_kr: record.description_kr, description_cn: record.description_kr,
          url_news: record.url_news, publish_date: record.publish_date, is_highlight: record.is_highlight, offer_type: record.offer_type, attachment_id: record.attachment_id, 
          created_at: record.created_at, updated_at: record.updated_at, time_end: record.time_end, index_order: record.index_order, is_discover: record.is_discover, banner_attachment: record.banner_attachment)
        elsif record.title_cn.present? && record.description_cn.present? && user.language.to_s == 'zh'
          data_tmp = Offer.new(id: record.id, title: record.title_cn, title_ja: record.title_cn, title_kr: record.title_cn, title_cn: record.title_cn,
          description: record.description_cn, description_ja: record.description_cn, description_kr: record.description_cn, description_cn: record.description_cn, 
          url_news: record.url_news, publish_date: record.publish_date, is_highlight: record.is_highlight, offer_type: record.offer_type, attachment_id: record.attachment_id, 
          created_at: record.created_at, updated_at: record.updated_at, time_end: record.time_end, index_order: record.index_order, is_discover: record.is_discover, banner_attachment: record.banner_attachment)
        else
          data_tmp = Offer.new(id: record.id, title: record.title, title_ja: record.title, title_kr: record.title, title_cn: record.title,
          description: record.description, description_ja: record.description, description_kr: record.description, description_cn: record.description,
          url_news: record.url_news, publish_date: record.publish_date, is_highlight: record.is_highlight, offer_type: record.offer_type, attachment_id: record.attachment_id, 
          created_at: record.created_at, updated_at: record.updated_at, time_end: record.time_end, index_order: record.index_order, is_discover: record.is_discover, banner_attachment: record.banner_attachment)
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