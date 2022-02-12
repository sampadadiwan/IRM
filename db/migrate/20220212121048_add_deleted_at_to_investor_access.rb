class AddDeletedAtToInvestorAccess < ActiveRecord::Migration[7.0]
  def change
    add_column :investor_accesses, :deleted_at, :datetime
    add_index :investor_accesses, :deleted_at
  end
end
