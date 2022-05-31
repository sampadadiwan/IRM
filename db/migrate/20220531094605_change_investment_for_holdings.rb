class ChangeInvestmentForHoldings < ActiveRecord::Migration[7.0]
  def change
    change_column_null :holdings, :investment_id, true
  end
end
