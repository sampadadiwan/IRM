class CreateDealMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :deal_messages do |t|
      t.references :user, null: false, foreign_key: true
      t.references :deal_investor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
