class Introduction < ApplicationRecord
    belongs_to :attachment, optional: true
    include Filterable
    scope :by_index, -> (index) {where index: index}
end
