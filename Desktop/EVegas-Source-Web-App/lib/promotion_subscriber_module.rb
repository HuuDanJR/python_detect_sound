module PromotionSubscriberModule
  include CommonModule
  include DaoModule

  PROMOTION_SUBSCRIBER_ATTRIBUTE = ClassAttribute.new
  PROMOTION_SUBSCRIBER_ATTRIBUTE.clazz = PromotionSubscriber
  PROMOTION_SUBSCRIBER_ATTRIBUTE.object_key = "promotion_subscriber"
  PROMOTION_SUBSCRIBER_ATTRIBUTE.filter_params = ["by_promotion_id", "by_user_id"]
  PROMOTION_SUBSCRIBER_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  PROMOTION_SUBSCRIBER_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  PROMOTION_SUBSCRIBER_ATTRIBUTE.create_params = ["user_id", "promotion_id", "time_send", "is_send"]
  PROMOTION_SUBSCRIBER_ATTRIBUTE.update_params = ["user_id", "promotion_id", "time_send", "is_send"]
  PROMOTION_SUBSCRIBER_ATTRIBUTE.include_object_params = {
  }

end