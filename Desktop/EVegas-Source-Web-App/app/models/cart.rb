class Cart < ApplicationRecord
  belongs_to :customer
  belongs_to :product

  scope :by_customer, -> (customer) {where customer_id: customer}
end
