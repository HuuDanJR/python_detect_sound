module PromotionReactionModule
  include CommonModule
  include DaoModule

  PROMOTION_REACTIOM_ATTRIBUTE = ClassAttribute.new
  PROMOTION_REACTIOM_ATTRIBUTE.clazz = PromotionReaction
  PROMOTION_REACTIOM_ATTRIBUTE.object_key = "promotion_reaction"
  PROMOTION_REACTIOM_ATTRIBUTE.filter_params = ["by_promotion_id", "by_user_id"]
  PROMOTION_REACTIOM_ATTRIBUTE.index_except_params = ["created_at", "updated_at"]
  PROMOTION_REACTIOM_ATTRIBUTE.show_except_params = ["created_at", "updated_at"]
  PROMOTION_REACTIOM_ATTRIBUTE.create_params = ["user_id", "promotion_id", "reaction_type"]
  PROMOTION_REACTIOM_ATTRIBUTE.update_params = ["user_id", "promotion_id", "reaction_type"]
  PROMOTION_REACTIOM_ATTRIBUTE.include_object_params = {
  }

end