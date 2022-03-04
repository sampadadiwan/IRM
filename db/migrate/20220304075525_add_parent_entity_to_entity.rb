class AddParentEntityToEntity < ActiveRecord::Migration[7.0]
  def change
    add_column :entities, :parent_entity_id, :integer
    add_index :entities, :parent_entity_id
  end
end
