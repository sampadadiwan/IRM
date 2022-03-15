class AddCacheCountersToEntity < ActiveRecord::Migration[7.0]
  def change
    add_column :entities, :tasks_count, :integer
    add_column :entities, :pending_accesses_count, :integer
    add_column :entities, :active_deal_id, :integer

    remove_column :entities, :funding_amount
    remove_column :entities, :funding_unit
    remove_column :entities, :investment_types    
  end
end
