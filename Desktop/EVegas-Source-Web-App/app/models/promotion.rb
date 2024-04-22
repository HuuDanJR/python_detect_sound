class Promotion < ApplicationRecord
  belongs_to :attachment, optional: true
  belongs_to :promotion_category, optional: true
end
