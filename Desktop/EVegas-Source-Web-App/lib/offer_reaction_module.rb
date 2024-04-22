module OfferReactionModule
  include CommonModule
  include DaoModule

  OFFER_REACTIOM_ATTRIBUTE = ClassAttribute.new
  OFFER_REACTIOM_ATTRIBUTE.clazz = OfferReaction
  OFFER_REACTIOM_ATTRIBUTE.object_key = "offer_reaction"
  OFFER_REACTIOM_ATTRIBUTE.filter_params = ["by_offer_id", "by_user_id"]
  OFFER_REACTIOM_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  OFFER_REACTIOM_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  OFFER_REACTIOM_ATTRIBUTE.create_params = ["user_id", "offer_id", "reaction_type"]
  OFFER_REACTIOM_ATTRIBUTE.update_params = ["user_id", "offer_id", "reaction_type"]
  OFFER_REACTIOM_ATTRIBUTE.include_object_params = {
  }

end