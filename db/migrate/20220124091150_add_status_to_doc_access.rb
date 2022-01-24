class AddStatusToDocAccess < ActiveRecord::Migration[7.0]
  def change
    add_column :doc_accesses, :status, :string, limit: 10
  end
end
