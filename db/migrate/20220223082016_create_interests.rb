class CreateInterests < ActiveRecord::Migration[7.0]
  def change
    create_table :interests do |t|
      t.integer :offer_entity_id
      t.integer :quantity
      t.decimal :price
      t.references :user, null: false, foreign_key: true
      t.integer :interest_entity_id
      t.references :secondary_sale, null: false, foreign_key: true

      t.timestamps
    end
    add_index :interests, :offer_entity_id
    add_index :interests, :interest_entity_id
  end
end
