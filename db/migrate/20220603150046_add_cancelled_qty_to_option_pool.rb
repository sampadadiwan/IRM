class AddCancelledQtyToOptionPool < ActiveRecord::Migration[7.0]
  def change
    add_column :option_pools, :cancelled_quantity, :bigint, default: 0
  end
end
