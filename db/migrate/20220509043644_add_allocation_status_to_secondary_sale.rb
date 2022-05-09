class AddAllocationStatusToSecondarySale < ActiveRecord::Migration[7.0]
  def change
    add_column :secondary_sales, :allocation_status, :string, limit: 10
  end
end
