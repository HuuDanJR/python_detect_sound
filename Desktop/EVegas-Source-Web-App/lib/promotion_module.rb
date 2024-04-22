module PromotionModule
  include CommonModule
  include DaoModule

  PROMOTION_ATTRIBUTE = ClassAttribute.new
  PROMOTION_ATTRIBUTE.clazz = Promotion
  PROMOTION_ATTRIBUTE.object_key = "Promotion"
  PROMOTION_ATTRIBUTE.filter_params = ["search"]
  PROMOTION_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  PROMOTION_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  PROMOTION_ATTRIBUTE.include_object_params = {
    "promotion_category" => ["id", "name", "phone", "attachment_id"]
  }

end