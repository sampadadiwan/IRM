class AddIndexToDeletedAt < ActiveRecord::Migration[7.0]
  def change
    add_index :entities, :deleted_at
    add_index :investors, :deleted_at
    add_index :documents, :deleted_at
    add_index :notes, :deleted_at
    add_index :access_rights, :deleted_at
    add_index :deals, :deleted_at
    add_index :deal_investors, :deleted_at
    add_index :deal_activities, :deleted_at
    add_index :deal_messages, :deleted_at
    add_index :deal_docs, :deleted_at
    add_index :roles, :deleted_at
    add_index :users, :deleted_at
    add_index :investments, :deleted_at
  end
end
