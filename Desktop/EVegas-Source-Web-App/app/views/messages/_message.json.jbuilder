json.extract! message, :id, :content, :content_ja, :content_kr, :content_cn, :title, :title_ja, :title_kr, :title_cn, :short_description, :short_description_ja, :short_description_kr, :short_description_cn, :language, :name, :is_draft, :created_at, :updated_at
json.url message_url(message, format: :json)
