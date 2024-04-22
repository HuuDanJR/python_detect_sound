class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_products
  has_many :products, through: :order_products

  scope :by_customer, -> (customer) {where customer_id: customer}
end
