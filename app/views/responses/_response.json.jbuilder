json.extract! poll, :id, :vote, :created_at, :updated_at
json.url response_url(poll, format: :json)
