class AddEntityIdToDealMessage < ActiveRecord::Migration[7.0]
  def change
    add_column :deal_messages, :entity_id, :bigint, null: false
    add_index :deal_messages, :entity_id
  end
end
