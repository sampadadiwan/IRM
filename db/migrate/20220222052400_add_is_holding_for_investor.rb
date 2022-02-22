class AddIsHoldingForInvestor < ActiveRecord::Migration[7.0]
  def change
    add_column :investors, :is_holdings_entity, :boolean, default: false
    add_column :entities, :is_holdings_entity, :boolean, default: false
  end
end
