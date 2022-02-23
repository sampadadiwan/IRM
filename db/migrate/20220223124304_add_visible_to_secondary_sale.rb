class AddVisibleToSecondarySale < ActiveRecord::Migration[7.0]
  def change
    add_column :secondary_sales, :visible_externally, :boolean, default: false
  end
end
