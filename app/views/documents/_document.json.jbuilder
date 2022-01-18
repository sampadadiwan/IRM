json.extract! document, :id, :name, :doc_type, :owner_id, :owner_type, :created_at, :updated_at
json.url document_url(document, format: :json)
