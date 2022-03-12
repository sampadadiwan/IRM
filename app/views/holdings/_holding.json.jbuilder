json.extract! holding, :id, :user_id, :entity_id, :quantity, :value, :created_at, :investment_instrument
json.url holding_url(holding, format: :json)
json.entity_name holding.entity.name
json.holder_name holding.holder_name
