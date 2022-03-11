class AddClosedOnToFundingRound < ActiveRecord::Migration[7.0]
  def change
    add_column :funding_rounds, :closed_on, :date
  end
end
