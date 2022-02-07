json.extract! entity, :id, :name, :url, :category, :founded, :entity_type, :logo_url,
              :funding_amount, :funding_unit, :created_at, :updated_at, :details
json.url entity_url(entity, format: :json)
