class CreateHoldingActions < ActiveRecord::Migration[7.0]
  def change
    create_table :holding_actions do |t|
      t.references :entity, null: false, foreign_key: true
      t.references :holding, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.integer :quantity
      t.string :action, limit: 20
      t.text :notes

      t.timestamps
    end
  end
end
