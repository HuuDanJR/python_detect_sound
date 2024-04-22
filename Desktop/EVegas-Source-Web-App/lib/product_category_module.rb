module ProductCategoryModule
  include CommonModule
  include DaoModule

  PRODUCT_CATEGORY_ATTRIBUTE = ClassAttribute.new
  PRODUCT_CATEGORY_ATTRIBUTE.clazz = ProductCategory
  PRODUCT_CATEGORY_ATTRIBUTE.object_key = "product_category"
  PRODUCT_CATEGORY_ATTRIBUTE.filter_params = ["search"]
  PRODUCT_CATEGORY_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  PRODUCT_CATEGORY_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  PRODUCT_CATEGORY_ATTRIBUTE.include_object_params = {
  }

end