class CreateInvestorAccesses < ActiveRecord::Migration[7.0]
  def change
    create_table :investor_accesses do |t|
      t.integer :investor_id
      t.integer :user_id
      t.string :email
      t.boolean :approved
      t.integer :granted_by
      t.integer :entity_id

      t.timestamps
    end
    add_index :investor_accesses, :investor_id
    add_index :investor_accesses, :user_id
    add_index :investor_accesses, :email
    add_index :investor_accesses, :entity_id
  end
end
