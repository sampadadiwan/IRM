class RenameTaxInExcercise < ActiveRecord::Migration[7.0]
  def change
    rename_column :excercises, :tax, :tax_cents
    rename_column :excercises, :price, :price_cents
    rename_column :excercises, :amount, :amount_cents
    
  end
end
