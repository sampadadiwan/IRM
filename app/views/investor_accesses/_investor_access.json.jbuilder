json.extract! investor_access, :id, :investor_id, :email, :access_type, :granted_by, :created_at, :updated_at
json.url investor_access_url(investor_access, format: :json)
