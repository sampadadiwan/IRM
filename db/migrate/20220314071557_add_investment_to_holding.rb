class AddInvestmentToHolding < ActiveRecord::Migration[7.0]
  def change
    add_reference :holdings, :investment, null: false, foreign_key: true
  end
end
