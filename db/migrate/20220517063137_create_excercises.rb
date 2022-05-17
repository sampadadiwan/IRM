class CreateExcercises < ActiveRecord::Migration[7.0]
  def change
    create_table :excercises do |t|
      t.references :entity, null: false, foreign_key: true
      t.references :holding, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :esop_pool, null: false, foreign_key: true
      t.integer :quantity, default: 0
      t.decimal :price, precision: 20, scale: 2, default: 0
      t.decimal :amount, precision: 20, scale: 2, default: 0
      t.decimal :tax, precision: 20, scale: 2, default: 0
      t.boolean :approved, default: false

      t.timestamps
    end
  end
end
