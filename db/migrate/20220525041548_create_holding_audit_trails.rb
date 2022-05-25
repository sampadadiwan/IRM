class CreateHoldingAuditTrails < ActiveRecord::Migration[7.0]
  def change
    create_table :holding_audit_trails do |t|
      t.string :action, limit: 100
      t.bigint :parent_id
      t.string :owner, limit: 30
      t.bigint :quantity
      t.integer :operation
      t.boolean :completed, default: false 
      t.references :ref, polymorphic: true, null: false
      t.text :comments
      t.references :entity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
