class AddDeletedAtToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :deleted_at, :datetime
    add_index :payments, :deleted_at
  end
end
