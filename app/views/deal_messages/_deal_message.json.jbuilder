json.extract! deal_message, :id, :user_id, :content, :deal_investor_id, :created_at, :updated_at
json.url deal_message_url(deal_message, format: :json)
json.content deal_message.content.to_s
