class AddPriceToHolding < ActiveRecord::Migration[7.0]
  def change
    add_column :holdings, :price_cents, :decimal, precision: 20, scale: 2, default: "0"
  end
end
