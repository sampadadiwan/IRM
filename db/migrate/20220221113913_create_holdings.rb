class CreateHoldings < ActiveRecord::Migration[7.0]
  def change
    create_table :holdings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :entity, null: false, foreign_key: true
      t.integer :quantity, default: 0
      t.decimal :value, precision: 20, default: 0

      t.timestamps
    end
  end
end
