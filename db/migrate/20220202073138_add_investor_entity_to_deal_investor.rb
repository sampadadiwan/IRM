class AddInvestorEntityToDealInvestor < ActiveRecord::Migration[7.0]
  def change
    add_column :deal_investors, :investor_entity_id, :integer
    add_index :deal_investors, :investor_entity_id
  end
end
