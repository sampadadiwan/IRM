json.extract! company, :id, :name, :url, :category, :founded, :company_type, :logo_url,
:funding_amount, :funding_unit, :created_at, :updated_at, :details
json.url company_url(company, format: :json)