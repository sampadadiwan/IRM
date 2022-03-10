class AddFundingRoundToInvestment < ActiveRecord::Migration[7.0]
  def change
    add_reference :investments, :funding_round, null: true, foreign_key: true
    add_column :funding_rounds, :amount_raised_cents, :decimal, precision: 20, scale: 2, default: "0"
    add_column :funding_rounds, :status, :string, default: "Open"
  end
end
