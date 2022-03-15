class AddDeletedAtToSecondarySale < ActiveRecord::Migration[7.0]
  def change
    add_column :secondary_sales, :deleted_at, :datetime
    add_index :secondary_sales, :deleted_at
  end
end
