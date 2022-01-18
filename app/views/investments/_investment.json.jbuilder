json.extract! investment, :id, :investment_type, :investor_company_id, :investee_company_id, :investor_type, :investment_instrument, :quantity, :intial_value, :current_value, :created_at, :updated_at
json.url investment_url(investment, format: :json)
