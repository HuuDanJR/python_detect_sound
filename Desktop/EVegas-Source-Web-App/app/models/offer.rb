class Offer < ApplicationRecord
  before_validation :set_default_date
  belongs_to :attachment, optional: true
  has_many :offer_reactions
  
  include Filterable
  scope :by_is_highlight, -> (is_highlight) {where is_highlight: is_highlight}
  scope :by_publish_date, -> (publish_date) {where("publish_date <= ?", publish_date)}
  scope :by_offer_type, -> (offer_type) {where offer_type: offer_type}
  scope :by_time_end, -> (time_end) {where("time_end >= ?", time_end)}
  
  def set_default_date
    self.publish_date ||= DateTime.now
    self.time_end ||= DateTime.now
  end

end
