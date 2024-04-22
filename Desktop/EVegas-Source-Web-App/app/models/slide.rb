class Slide < ApplicationRecord
    belongs_to :attachment, optional: true
    include Filterable
    scope :by_name, -> (name) {where name: name}
    scope :by_index, -> (index) {where index: index}
    scope :by_is_show, -> (is_show) {where is_show: is_show}
end
