module OrderModule
  include CommonModule
  include DaoModule
  include NotificationModule

  ORDER_ATTRIBUTE = ClassAttribute.new
  ORDER_ATTRIBUTE.clazz = Order
  ORDER_ATTRIBUTE.object_key = "order"
  ORDER_ATTRIBUTE.filter_params = ["by_customer"]
  ORDER_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  ORDER_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  ORDER_ATTRIBUTE.create_params = ["customer_id", "status"]
  ORDER_ATTRIBUTE.include_object_params = {
      "customer" => ["id", "forename"],
      "order_products" => ["id", "product_id", "quantity", "unit_price", "sub_total"],
      "products" => ["id", "name"]
  }

  def check_params_create_or_update(request_body)
    result = ResultHandler.new

    customer_prop = request_body['customer_id']
    if is_blank(customer_prop) || !is_number(customer_prop)
      result.set_error_data(:bad_request, I18n.t('messages.invalid_param'))
      return result
    end

    carts_prop = request_body['carts']
    if carts_prop.nil?
      result.set_error_data(:bad_request, I18n.t('messages.invalid_param'))
      return result
    end
    if carts_prop.length == 0
      result.set_error_data(:bad_request, I18n.t('messages.invalid_param'))
      return result
    end
    if have_any_empty_property(carts_prop)
      result.set_error_data(:bad_request, I18n.t('messages.missing_param'))
      return result
    end

    return result
  end

  def create_object(clazz, object_key, create_params)
    result = ResultHandler.new
    
    ActiveRecord::Base::transaction do
      # Create a new order
      order = Order.new
      order.customer_id = @request_body['customer_id']
      order.total = 0
      order.status = 0
      if !order.save
        result.set_error_data(:unprocessable_entity, order.errors)
        raise ActiveRecord::Rollback
      end

      order_total = 0

      # Create a new order product
      if !@request_body['carts'].nil?
        @request_body['carts'].each do |item|
          
          cart_item = Cart.where("id = ? AND customer_id = ?", item['id'], @request_body['customer_id']).first
          if cart_item.nil?
            # Not found cart item
            result.set_error_data(:not_found, I18n.t('messages.object_not_found'))
            raise ActiveRecord::Rollback
            return result
          else
            # Create a new order product
            order_product = OrderProduct.new
            order_product.order_id = order.id
            order_product.product_id = cart_item.product_id
            order_product.quantity = cart_item.quantity
            order_product.unit_price = cart_item.product.point_price
            order_product.sub_total = order_product.quantity * order_product.unit_price
            if order_product.save
              order_total += order_product.sub_total
            else
              result.set_error_data(:unprocessable_entity, order_product.errors)
              raise ActiveRecord::Rollback
            end

            # Remove cart item
            if !cart_item.destroy
              result.set_error_data(:unprocessable_entity, cart_item.errors)
              raise ActiveRecord::Rollback
            end
          end
        end
      end
      
      result = check_point_customer(@request_body['customer_id'], order_total)
      if result.result == false
        raise ActiveRecord::Rollback
        return result
      end

      # Update order info
      order.total = order_total
      order.status = @request_body['status'].to_i
      if order.save
        result.set_success_data(:ok, order)
        # TODO: Send notification to user
        #
        status = @request_body['status'].to_i
        user_cus = Customer.where('id = ?', order.customer_id.to_i).first
        setting_message = JSON.parse(Setting.where('setting_key = ?', 'ORDER_BOOKING_CONFIG').first().setting_value)
        if !user_cus.nil?
          notification = Notification.new
          notification.user_id = user_cus.user_id
          notification.source_id = order.id
          notification.source_type = "orders"
          notification.notification_type = 4
          notification.status_type = 1
          notification.status = 1
          setting_message['status'].each do |item|
            if status == item['id']
              notification.title = item['message']
              break
            end
          end
          notification.title = notification.title
          if notification.save
            send_notification_to_user(user_cus.user_id, notification.title, "orders", notification.source_id, notification.id, nil, "")
            if order.status == 1
              message = "Customer " + user_cus.forename.to_s + " number #" + user_cus.number.to_s + " order"
              send_notification_to_user_web("New order", message, "orders", notification.source_id)
            end
          end
        end
      else
        result.set_error_data(:unprocessable_entity, order.errors)
        raise ActiveRecord::Rollback
      end
    end

    return result
  end

  def check_point_customer(customer_id, total)
    result = ResultHandler.new
    is_used_fb_point = Setting.where('setting_key = ?', 'IS_USED_FB_POINT').first!.setting_value
    if is_used_fb_point.to_s == 'false'
      return result
    end

    customer = Customer.find(customer_id)
    vegas_internal_api = Setting.where('setting_key = ?', 'VC_INTERNAL_API').first!.setting_value

    req_body = {
      id: "100=" + customer.card_number   
    }
    res_data = get_content_from_url(vegas_internal_api + "/api/point_by_date_cardtrack", :post, req_body)
    if res_data.result
      res_data_json = JSON.parse(res_data.data)['data']
      if !res_data_json.nil?
        loyalty_point = res_data_json['LoyaltyPoints']
        if loyalty_point >= total
          result.set_success_data(:ok, {})
        else
          result.set_error_data(:bad_request, "You have not enough points!")
        end
      end
    end

    return result
  end

  def validate_get_order_id(_order_id)
    result = ResultHandler.new
    _order_id = _order_id.to_i
    
    if (is_blank(_order_id))
      result.set_error_data(:bad_request, I18n.t('messages.object_to_required'))
      return result
    end

    return result
  end

end