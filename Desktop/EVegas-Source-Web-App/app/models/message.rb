class Message < ApplicationRecord
    scope :by_language, -> (language) {where language: language}
    scope :by_category, -> (category) {where category: category}
end
