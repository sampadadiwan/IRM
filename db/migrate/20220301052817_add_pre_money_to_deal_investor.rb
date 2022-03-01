class AddPreMoneyToDealInvestor < ActiveRecord::Migration[7.0]
  def change
    add_column :deal_investors, :pre_money_valuation, :decimal, precision: 20, scale: 2, default: "0.0"
    add_column :deal_investors, :company_advisor, :string, limit: 100
    add_column :deal_investors, :investor_advisor, :string, limit: 100     
  end
end
