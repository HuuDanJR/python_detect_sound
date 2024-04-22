class Accommodation < ApplicationRecord
    belongs_to :customer
    
    scope :by_customer, -> (customer) {where customer_id: customer}
    scope :by_status, -> (status) {where status: status}
end
