class AddAllocatedQuantityToEsopPool < ActiveRecord::Migration[7.0]
  def change
    add_column :esop_pools, :allocated_quantity, :bigint, default: 0
    add_column :esop_pools, :excercised_quantity, :bigint, default: 0
  end
end
