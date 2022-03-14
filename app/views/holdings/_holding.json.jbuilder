json.extract! holding, :id, :user_id, :entity_id, :quantity,
              :created_at, :investment_instrument
json.url holding_url(holding, format: :json)
json.entity_name holding.entity.name
json.holder_name holding.holder_name
json.price custom_format_number (holding.price_cents / 100), {}, true
json.value money_to_currency holding.value
