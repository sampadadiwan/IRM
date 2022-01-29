class CreateDealInvestors < ActiveRecord::Migration[7.0]
  def change
    create_table :deal_investors do |t|
      t.references :deal, null: false, foreign_key: true
      t.references :investor, null: false, foreign_key: true
      t.string :status, limit: 20
      t.decimal :primary_amount
      t.decimal :secondary_investment
      t.references :entity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
