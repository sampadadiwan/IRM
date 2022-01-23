class CreateInvestorAccesses < ActiveRecord::Migration[7.0]
  def change
    create_table :investor_accesses do |t|
      t.integer :investor_id
      t.string :email
      t.string :access_type, limit: 30
      t.integer :granted_by

      t.timestamps
    end
    add_index :investor_accesses, :investor_id
    add_index :investor_accesses, :email
  end
end
