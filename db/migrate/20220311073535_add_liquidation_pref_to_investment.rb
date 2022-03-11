class AddLiquidationPrefToInvestment < ActiveRecord::Migration[7.0]
  def change
    add_column :investments, :liquidation_preference, :decimal, precision: 4, scale: 2
  end
end
