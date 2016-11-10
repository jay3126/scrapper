json.extract! scrapper, :id, :user_id, :url, :created_at, :updated_at
json.url scrapper_url(scrapper, format: :json)