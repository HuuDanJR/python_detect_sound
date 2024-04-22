class OfficerCustomer < ApplicationRecord
  belongs_to :officer
  belongs_to :customer

  scope :by_customer, -> (customer) {where customer_id: customer}
end
