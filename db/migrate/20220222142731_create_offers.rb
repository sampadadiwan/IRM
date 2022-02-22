class CreateOffers < ActiveRecord::Migration[7.0]
  def change
    create_table :offers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :entity, null: false, foreign_key: true
      t.references :secondary_sale, null: false, foreign_key: true
      t.integer :quantity, default:0
      t.decimal :percentage, default:0
      t.text :notes

      t.timestamps
    end
  end
end
