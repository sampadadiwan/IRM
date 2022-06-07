class AddNameToInvestorAccess < ActiveRecord::Migration[7.0]
  def change
    add_column :investor_accesses, :first_name, :string, limit: 20
    add_column :investor_accesses, :last_name, :string, limit: 20
  end
end
