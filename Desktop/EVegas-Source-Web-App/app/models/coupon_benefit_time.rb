class CouponBenefitTime < ApplicationRecord
    before_validation :set_time_used
    belongs_to :benefit, optional: true
    belongs_to :coupon, optional: true
    
    def set_time_used
        self.time_used ||= DateTime.now
    end
end
