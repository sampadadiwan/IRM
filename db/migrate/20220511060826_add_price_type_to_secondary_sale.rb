class AddPriceTypeToSecondarySale < ActiveRecord::Migration[7.0]
  def change
    add_column :secondary_sales, :price_type, :string, limit: 15
  end
end
