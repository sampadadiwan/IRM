class AddDeletedAtToEntity < ActiveRecord::Migration[7.0]
  def change
    add_column :entities, :deleted_at, :datetime
    add_column :investors, :deleted_at, :datetime
    add_column :documents, :deleted_at, :datetime
    add_column :notes, :deleted_at, :datetime
    add_column :access_rights, :deleted_at, :datetime
    add_column :deals, :deleted_at, :datetime
    add_column :deal_investors, :deleted_at, :datetime
    add_column :deal_activities, :deleted_at, :datetime
    add_column :deal_messages, :deleted_at, :datetime
    add_column :deal_docs, :deleted_at, :datetime
    add_column :roles, :deleted_at, :datetime
  end
end
