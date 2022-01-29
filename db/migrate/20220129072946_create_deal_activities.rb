class CreateDealActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :deal_activities do |t|
      t.references :deal, null: false, foreign_key: true
      t.references :deal_investor, null: false, foreign_key: true
      t.date :by_date
      t.string :status, limit: 20
      t.boolean :completed
      t.integer :entity_id

      t.timestamps
    end

    add_index :deal_activities, :entity_id
  end
end
