class Product < ApplicationRecord
  belongs_to :attachment, optional: true
  belongs_to :product_category, optional: true
  
  include Filterable
  scope :by_qrcode, -> (qrcode) {where qrcode: qrcode}
  scope :by_product_category_id, -> (product_category_id) {where product_category_id: product_category_id}
  scope :by_beverage_type, -> (beverage_type) {where beverage_type: beverage_type}
  scope :by_product_type, -> (product_type) {where product_type: product_type}
  scope :by_customer_level, -> (customer_level) {where("customer_level REGEXP ? OR customer_level IS NULL OR customer_level = ''", '"' + "#{customer_level}" + '"')}
  scope :search, -> (query) {where("name LIKE ? ", "%#{query}%")}
end
