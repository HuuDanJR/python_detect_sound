module ProductModule
  include CommonModule
  include DaoModule

  PRODUCT_ATTRIBUTE = ClassAttribute.new
  PRODUCT_ATTRIBUTE.clazz = Product
  PRODUCT_ATTRIBUTE.object_key = "product"
  PRODUCT_ATTRIBUTE.filter_params = ["search", "by_qrcode", "by_product_category_id", "by_customer_level", "by_product_type", "by_beverage_type"]
  PRODUCT_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  PRODUCT_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  PRODUCT_ATTRIBUTE.include_object_params = {
      "attachment" => ["id", "name", "category"],
      "product_category" => ["id", "name"]
  }

end