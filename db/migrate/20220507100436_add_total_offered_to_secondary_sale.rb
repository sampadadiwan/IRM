class AddTotalOfferedToSecondarySale < ActiveRecord::Migration[7.0]
  def change
    add_column :secondary_sales, :final_price, :decimal, precision: 10, scale: 2, default: 0
    add_column :secondary_sales, :total_offered_amount_cents, :decimal, precision: 20, scale: 2, default: 0
    add_column :secondary_sales, :total_interest_amount_cents, :decimal, precision: 20, scale: 2, default: 0
    add_column :secondary_sales, :total_interest_quantity, :integer, default: 0
    add_column :secondary_sales, :allocation_percentage, :decimal, precision: 5, scale: 2, default: 0

    add_column :offers, :final_price, :decimal, precision: 10, scale: 2, default: 0
    add_column :offers, :amount_cents, :decimal, precision: 20, scale: 2, default: 0
    
    add_column :interests, :final_price, :decimal, precision: 10, scale: 2, default: 0
    add_column :interests, :amount_cents, :decimal, precision: 20, scale: 2, default: 0
    
  end
end
