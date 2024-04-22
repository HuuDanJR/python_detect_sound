class Officer < ApplicationRecord
    # has_many :officer_attachments, dependent: :destroy
    # has_many :attachments, through: :officer_attachments
    # has_many :officer_languages, dependent: :destroy
    belongs_to :user, optional: true
    belongs_to :attachment, optional: true
    validates :name, presence: true

    include Filterable
    scope :by_status, -> (status) {where status: status}
    scope :search, -> (query) {where("name LIKE ?", "%#{query}%")}
end
