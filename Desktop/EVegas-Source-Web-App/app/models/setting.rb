class Setting < ApplicationRecord
    include Filterable
    scope :by_setting_key, -> (setting_key) {where setting_key: setting_key}
end
