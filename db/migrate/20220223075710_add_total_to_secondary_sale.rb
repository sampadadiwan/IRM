class AddTotalToSecondarySale < ActiveRecord::Migration[7.0]
  def change
    add_column :secondary_sales, :total_offered_quantity, :integer, default: 0
  end
end
