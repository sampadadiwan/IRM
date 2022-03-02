class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :entity, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, default: 0, null: false
      t.string :plan, limit: 30
      t.decimal :discount, precision: 10, scale: 2, default: 0
      t.string :reference_number
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
