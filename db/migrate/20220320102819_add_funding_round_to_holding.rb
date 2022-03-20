class AddFundingRoundToHolding < ActiveRecord::Migration[7.0]
  def change
    add_reference :holdings, :funding_round, null: false, foreign_key: true
  end
end
