class JackpotGameType < ApplicationRecord
    has_many :jackpot_machines
    
    include Filterable
    scope :by_status, -> (status) {where status: status}
    scope :search, -> (query) {where("name LIKE ?", "%#{query}%")}
end
