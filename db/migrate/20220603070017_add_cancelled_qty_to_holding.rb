class AddCancelledQtyToHolding < ActiveRecord::Migration[7.0]
  def change
    add_column :holdings, :cancelled_quantity, :integer, default: 0
    add_column :holdings, :uncancelled_quantity, :integer, default: 0
  end
end
