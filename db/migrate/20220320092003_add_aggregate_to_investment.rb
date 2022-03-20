class AddAggregateToInvestment < ActiveRecord::Migration[7.0]
  def change
    add_reference :investments, :aggregate_investment, null: true, foreign_key: true
  end
end
