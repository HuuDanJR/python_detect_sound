json.extract! user_first_login, :id, :created_at, :updated_at
json.url user_first_login_url(user_first_login, format: :json)
