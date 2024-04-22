class UserFirstLogin < ApplicationRecord
    belongs_to :user, optional: true
end
