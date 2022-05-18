class CreateValuations < ActiveRecord::Migration[7.0]
  def change
    create_table :valuations do |t|
      t.references :entity, null: false, foreign_key: true
      t.date :valuation_date
      t.decimal :pre_money_valuation_cents, precision: 20, scale: 2, default: 0
      t.decimal :per_share_value_cents, precision: 15, scale: 2, default: 0

      t.timestamps
    end
  end
end
