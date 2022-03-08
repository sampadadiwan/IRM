class AddPriceCentsToInvestment < ActiveRecord::Migration[7.0]
  def change
    add_column :investments, :price_cents, :decimal, precision: 10, scale: 2, default: "0"
    remove_column :investments, :price
  end
end
