module OfferSubscriberModule
  include CommonModule
  include DaoModule

  OFFER_SUBSCRIBER_ATTRIBUTE = ClassAttribute.new
  OFFER_SUBSCRIBER_ATTRIBUTE.clazz = OfferSubscriber
  OFFER_SUBSCRIBER_ATTRIBUTE.object_key = "offer_subscriber"
  OFFER_SUBSCRIBER_ATTRIBUTE.filter_params = ["by_offer_id", "by_user_id"]
  OFFER_SUBSCRIBER_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  OFFER_SUBSCRIBER_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  OFFER_SUBSCRIBER_ATTRIBUTE.create_params = ["user_id", "offer_id", "time_send", "is_send"]
  OFFER_SUBSCRIBER_ATTRIBUTE.update_params = ["user_id", "offer_id", "time_send", "is_send"]
  OFFER_SUBSCRIBER_ATTRIBUTE.include_object_params = {
  }

end