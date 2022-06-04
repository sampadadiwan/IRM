class AddGrossToHolding < ActiveRecord::Migration[7.0]
  def change
    add_column :holdings, :gross_avail_to_excercise_quantity, :integer, default: 0
    add_column :holdings, :unexcercised_cancelled_quantity, :integer, default: 0
    add_column :holdings, :net_avail_to_excercise_quantity, :integer, default: 0
    add_column :holdings, :gross_unvested_quantity, :integer, default: 0
    add_column :holdings, :unvested_cancelled_quantity, :integer, default: 0
    add_column :holdings, :net_unvested_quantity, :integer, default: 0
    # remove_column :holdings, :cancelled_quantity, :integer, default: 0
    # remove_column :holdings, :uncancelled_quantity, :integer, default: 0

    add_column :option_pools, :gross_avail_to_excercise_quantity, :bigint, default: 0
    add_column :option_pools, :unexcercised_cancelled_quantity, :bigint, default: 0
    add_column :option_pools, :net_avail_to_excercise_quantity, :bigint, default: 0
    add_column :option_pools, :gross_unvested_quantity, :bigint, default: 0
    add_column :option_pools, :unvested_cancelled_quantity, :bigint, default: 0
    add_column :option_pools, :net_unvested_quantity, :bigint, default: 0
    # remove_column :option_pools, :cancelled_quantity, :bigint, default: 0

  end
end
