class CreateDealDocs < ActiveRecord::Migration[7.0]
  def change
    create_table :deal_docs do |t|
      t.string :name
      t.references :deal, null: false, foreign_key: true
      t.references :deal_investor, null: false, foreign_key: true
      t.references :deal_activity, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
