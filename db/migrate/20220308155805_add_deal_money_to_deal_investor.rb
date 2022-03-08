class AddDealMoneyToDealInvestor < ActiveRecord::Migration[7.0]
  def change
    rename_column :deals, :amount, :amount_cents
    rename_column :deal_investors, :primary_amount, :primary_amount_cents
    rename_column :deal_investors, :secondary_investment, :secondary_investment_cents
    rename_column :deal_investors, :pre_money_valuation, :pre_money_valuation_cents
  end
end
