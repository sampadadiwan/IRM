json.extract! doc_access, :id, :document_id, :visiblity_type, :to, :created_at, :updated_at
json.url doc_access_url(doc_access, format: :json)
