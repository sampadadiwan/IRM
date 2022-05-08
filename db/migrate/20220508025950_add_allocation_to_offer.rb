class AddAllocationToOffer < ActiveRecord::Migration[7.0]
  def change
    add_column :offers, :allocation_quantity, :bigint, default: 0
    add_column :offers, :allocation_amount_cents, :decimal, precision: 20, scale: 2, default: 0
    add_column :offers, :allocation_percentage, :decimal, precision: 5, scale: 2, default: 0
    add_column :interests, :allocation_quantity, :bigint, default: 0
    add_column :interests, :allocation_amount_cents, :decimal, precision: 20, scale: 2, default: 0
    add_column :interests, :allocation_percentage, :decimal, precision: 5, scale: 2, default: 0
    add_column :secondary_sales, :offer_allocation_quantity, :bigint, default: 0    
    add_column :secondary_sales, :interest_allocation_quantity, :bigint, default: 0   
    remove_column :secondary_sales, :allocation_percentage    
    add_column :secondary_sales, :allocation_percentage, :decimal, precision: 7, scale: 4, default: 0
    
  end
end
