json.extract! offer, :id, :title, :title_ja, :title_kr, :title_cn, :description, :description_ja, :description_kr, :description_cn, :url_news, :publish_date, :time_end, :is_highlight, :offer_type, :created_at, :updated_at
json.url offer_url(offer, format: :json)
