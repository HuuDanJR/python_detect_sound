class Customer < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :attachment, optional: true
    include Filterable
    scope :search, -> (query) {where("name LIKE ?", "%#{query}%")}
end
