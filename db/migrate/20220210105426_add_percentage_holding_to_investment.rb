class AddPercentageHoldingToInvestment < ActiveRecord::Migration[7.0]
  def change
    add_column :investments, :percentage_holding, :decimal, :precision => 5, :scale => 2
  end
end
