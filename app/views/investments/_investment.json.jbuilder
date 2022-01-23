json.extract! investment, :id, :investment_type, :investor_entity_id, :investee_entity_id, :investor_type, :investment_instrument, :quantity, :initial_value, :current_value, :created_at, :updated_at
json.url investment_url(investment, format: :json)
