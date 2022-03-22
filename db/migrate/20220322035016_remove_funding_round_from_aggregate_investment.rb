class RemoveFundingRoundFromAggregateInvestment < ActiveRecord::Migration[7.0]
  def change
    remove_reference :aggregate_investments, :funding_round
  end
end
