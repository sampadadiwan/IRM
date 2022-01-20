json.extract! company, :id, :name, :url, :category, :founded, :funding_amount, :funding_unit, :created_at, :updated_at
json.url company_url(company, format: :json)