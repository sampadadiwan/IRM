class AddVestedToEsopPool < ActiveRecord::Migration[7.0]
  def change
    add_column :esop_pools, :vested_quantity, :bigint, default: 0
    add_column :esop_pools, :lapsed_quantity, :bigint, default: 0
    add_column :holdings, :vested_quantity, :integer, default: 0
    add_column :holdings, :lapsed, :boolean, default: false
  end
end
