class StaffIntroduce < ApplicationRecord
    belongs_to :staff, optional: true
    include Filterable
    scope :by_staff_id, -> (staff_id) {where staff_id: staff_id}
end
