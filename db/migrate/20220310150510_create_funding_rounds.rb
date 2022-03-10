class CreateFundingRounds < ActiveRecord::Migration[7.0]
  def change
    create_table :funding_rounds do |t|
      t.string :name
      t.decimal :total_amount_cents, precision: 20, scale: 2, default: "0"
      t.string :currency, limit: 5
      t.decimal :pre_money_valuation_cents, precision: 20, scale: 2, default: "0"
      t.decimal :post_money_valuation_cents, precision: 20, scale: 2, default: "0"
      t.references :entity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
