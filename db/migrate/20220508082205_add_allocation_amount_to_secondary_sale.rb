class AddAllocationAmountToSecondarySale < ActiveRecord::Migration[7.0]
  def change
    add_column :secondary_sales, :allocation_offer_amount_cents, :decimal, precision: 20, scale: 2, default: 0
    add_column :secondary_sales, :allocation_interest_amount_cents, :decimal, precision: 20, scale: 2, default: 0
  end
end
