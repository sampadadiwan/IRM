class CreateSecondarySales < ActiveRecord::Migration[7.0]
  def change
    create_table :secondary_sales do |t|
      t.string :name
      t.references :entity, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.integer :percent_allowed, default: 0
      t.decimal :min_price, precision: 5, scale: 2
      t.decimal :max_price, precision: 5, scale: 2
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
