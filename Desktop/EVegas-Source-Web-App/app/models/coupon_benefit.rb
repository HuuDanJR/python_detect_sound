class CouponBenefit < ApplicationRecord
    before_validation :set_default_init
    belongs_to :benefit, optional: true
    belongs_to :coupon, optional: true

    def set_default_init
        self.count_usage ||= 0
        self.total_usage ||= 1
        self.status ||= 1
    end
end
