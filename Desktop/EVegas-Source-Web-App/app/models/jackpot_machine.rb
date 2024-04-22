class JackpotMachine < ApplicationRecord
    belongs_to :jackpot_game_type, optional: true

    include Filterable
    scope :by_status, -> (status) {where status: status}
    scope :search, -> (query) {where("mc_name LIKE ?", "%#{query}%")}
end
