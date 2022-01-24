class AddEnttyIdToInvestorAccess < ActiveRecord::Migration[7.0]
  def change
    add_column :investor_accesses, :entity_id, :integer
    add_index :investor_accesses, :entity_id
  end
end
