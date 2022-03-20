class AddAggregateToFundingRound < ActiveRecord::Migration[7.0]
  def change
    add_column :funding_rounds, :equity, :integer, default: 0
    add_column :funding_rounds, :preferred, :integer, default: 0
    add_column :funding_rounds, :option, :integer, default: 0
  end
end
