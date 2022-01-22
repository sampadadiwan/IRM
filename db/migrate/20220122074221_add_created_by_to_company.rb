class AddCreatedByToCompany < ActiveRecord::Migration[7.0]
  def change
    add_column :companies, :created_by, :integer
  end
end
