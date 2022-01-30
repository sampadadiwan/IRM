json.extract! deal_doc, :id, :name, :deal_id, :deal_investor_id, :deal_activity_id, :user_id, :created_at, :updated_at
json.url deal_doc_url(deal_doc, format: :json)
