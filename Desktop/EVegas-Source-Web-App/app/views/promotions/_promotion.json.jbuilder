json.extract! promotion, :id, :name, :terms, :prize, :issue_date, :game_type, :day_of_week, :day_of_month, :day_of_season, :time, :remark, :status, :attachment_id, :promotion_category_id, :created_at, :updated_at, :color, :banner_id, :promotion_type, :is_highlight
json.url promotion_url(promotion, format: :json)
