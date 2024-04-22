class OfferSubscriber < ApplicationRecord
    belongs_to :offer, optional: true
    belongs_to :user, optional: true
    
    scope :by_offer_id, -> (offer_id) {where("offer_id IN (#{offer_id})")}
    scope :by_user_id, -> (user_id) {where user_id: user_id}
end
