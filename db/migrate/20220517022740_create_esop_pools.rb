class CreateEsopPools < ActiveRecord::Migration[7.0]
  def change
    create_table :esop_pools do |t|
      t.string :name
      t.date :start_date
      t.bigint :number_of_options, default: 0
      t.decimal :excercise_price_cents, precision: 20, scale: 2, default: 0
      t.integer :excercise_period_months, default: 0
      t.references :entity, null: false, foreign_key: true
      t.references :funding_round, null: true, foreign_key: true

      t.timestamps
    end
  end
end
