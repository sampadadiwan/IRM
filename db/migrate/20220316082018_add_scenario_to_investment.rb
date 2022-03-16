class AddScenarioToInvestment < ActiveRecord::Migration[7.0]
  def change
    add_reference :investments, :scenario, null: false, foreign_key: true
  end
end
