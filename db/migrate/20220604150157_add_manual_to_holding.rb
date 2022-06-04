class AddManualToHolding < ActiveRecord::Migration[7.0]
  def change
    add_column :holdings, :manual_vesting, :boolean, default: false
    add_column :option_pools, :manual_vesting, :boolean, default: false
  end
end
