class AddIndexToDealInvestor < ActiveRecord::Migration[7.0]
  def change
    add_index :investors, [:investor_entity_id, :investee_entity_id], unique: true
    add_index :deal_investors, [:investor_id, :deal_id], unique: true
  end
end
