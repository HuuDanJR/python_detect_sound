class PromotionReaction < ApplicationRecord
    belongs_to :promotion, optional: true
    belongs_to :user, optional: true
    
    scope :by_promotion_id, -> (promotion_id) {where("promotion_id IN (#{promotion_id})")}
    scope :by_user_id, -> (user_id) {where user_id: user_id}
end
