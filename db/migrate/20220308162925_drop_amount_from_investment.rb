class DropAmountFromInvestment < ActiveRecord::Migration[7.0]
  def change
    remove_column :investments, :amount
  end
end
