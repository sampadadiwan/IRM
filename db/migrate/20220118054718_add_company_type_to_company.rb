class AddCompanyTypeToCompany < ActiveRecord::Migration[7.0]
  def change
    add_column :companies, :company_type, :string, limit: 15
  end
end
