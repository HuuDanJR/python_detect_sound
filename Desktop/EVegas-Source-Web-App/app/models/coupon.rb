class Coupon < ApplicationRecord
    before_validation :set_default_int
    belongs_to :customer
    has_many :coupon_benefits
    has_many :benefits, :through => :coupon_benefits

    scope :by_customer, -> (customer) {where customer_id: customer}
    scope :by_status, -> (status) {where status: status}
    scope :by_time_start, -> (time_start) {where("time_start >= ?", time_start)}
    scope :by_expired, -> (expired) {where("expired >= ?", expired)}

    def set_default_int
        self.status ||= 1
    end
end
