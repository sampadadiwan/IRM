json.extract! document, :id, :name, :visible_to, :owner_id, :owner_type, :created_at, :updated_at
json.url document_url(document, format: :json)
