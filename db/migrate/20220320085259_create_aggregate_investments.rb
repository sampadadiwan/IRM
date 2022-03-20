class CreateAggregateInvestments < ActiveRecord::Migration[7.0]
  def change
    create_table :aggregate_investments do |t|
      t.references :entity, null: false, foreign_key: true
      t.references :funding_round, null: false, foreign_key: true
      t.string :shareholder
      t.references :investor, null: false, foreign_key: true
      t.integer :equity, default: 0
      t.integer :preferred, default: 0
      t.integer :option, default: 0
      t.decimal :percentage, precision: 5, scale: 2, default: 0
      t.decimal :full_diluted_percentage, precision: 5, scale: 2, default: 0

      t.timestamps
    end
  end
end
