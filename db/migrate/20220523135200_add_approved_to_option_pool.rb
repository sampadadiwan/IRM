class AddApprovedToOptionPool < ActiveRecord::Migration[7.0]
  def change
    add_column :option_pools, :approved, :boolean, default: false
  end
end
