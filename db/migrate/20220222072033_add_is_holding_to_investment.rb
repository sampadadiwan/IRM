class AddIsHoldingToInvestment < ActiveRecord::Migration[7.0]
  def change
    add_column :investments, :employee_holdings, :boolean, default: false
  end
end
