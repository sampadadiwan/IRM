class CreateDeals < ActiveRecord::Migration[7.0]
  def change
    create_table :deals do |t|
      t.references :entity, null: false, foreign_key: true
      t.string :name, limit: 100
      t.decimal :amount
      t.string :status, limit: 20

      t.timestamps
    end
  end
end
