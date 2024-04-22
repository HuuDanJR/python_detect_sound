class Benefit < ApplicationRecord
    before_validation :set_default_init
    belongs_to :attachment, optional: true

    def set_default_init
        self.status ||= 1
    end
end
