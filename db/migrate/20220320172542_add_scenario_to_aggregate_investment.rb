class AddScenarioToAggregateInvestment < ActiveRecord::Migration[7.0]
  def change
    add_reference :aggregate_investments, :scenario, null: false, foreign_key: true
  end
end
