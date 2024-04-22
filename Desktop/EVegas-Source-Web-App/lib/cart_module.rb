module CartModule
  include CommonModule
  include DaoModule

  CART_ATTRIBUTE = ClassAttribute.new
  CART_ATTRIBUTE.clazz = Cart
  CART_ATTRIBUTE.object_key = "cart"
  CART_ATTRIBUTE.filter_params = ["by_customer"]
  CART_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  CART_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  CART_ATTRIBUTE.create_params = ["customer_id", "product_id", "quantity"]
  CART_ATTRIBUTE.update_params = ["quantity"]
  CART_ATTRIBUTE.include_object_params = {
      "customer" => ["id", "forename"],
      "product" => ["id", "name", "sku", "point_price", "attachment_id"]
  }

  def create_object(clazz, object_key, create_params)
    object_new = clazz.new(get_data_object_request_body(object_key, create_params))
    object = clazz.where("customer_id = ? AND product_id = ?", object_new.customer_id, object_new.product_id).first
    if object.nil?
      super
    else
      # Update quantity
      result = ResultHandler.new
      object.quantity += object_new.quantity
      ActiveRecord::Base::transaction do
        if object.save
          result.set_success_data(:ok, object)
        else
          result.set_error_data(:unprocessable_entity, object.errors)
          raise ActiveRecord::Rollback
        end
      end
      return result
    end
  end

  def update_object(object, object_key, update_params, request_body = nil)
    object_update = get_data_object_request_body(object_key, update_params)
    if object_update["quantity"] > 0
      super
    else
      # Remove cart item
      result = ResultHandler.new
      ActiveRecord::Base::transaction do
        if object.destroy
          result.set_success_data(:ok, {})
        else
          result.set_error_data(:unprocessable_entity, object.errors)
          raise ActiveRecord::Rollback
        end
      end
      return result
    end
  end

end