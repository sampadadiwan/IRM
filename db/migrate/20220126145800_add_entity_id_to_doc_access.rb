class AddEntityIdToDocAccess < ActiveRecord::Migration[7.0]
  def change
    add_column :doc_accesses, :entity_id, :integer
    add_index :doc_accesses, :entity_id
  end
end
