class AddInvestorNameToDealInvestor < ActiveRecord::Migration[7.0]
  def change
    add_column :deal_investors, :investor_name, :string
  end
end
