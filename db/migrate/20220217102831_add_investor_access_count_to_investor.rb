class AddInvestorAccessCountToInvestor < ActiveRecord::Migration[7.0]
  def change
    add_column :investors, :investor_accesses_count, :integer, default: 0
    add_column :investors, :unapproved_investor_access_count, :integer, default: 0
                           
  end
end
