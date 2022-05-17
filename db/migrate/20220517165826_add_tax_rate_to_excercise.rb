class AddTaxRateToExcercise < ActiveRecord::Migration[7.0]
  def change
    add_column :excercises, :tax_rate, :decimal, precision: 5, scale: 2, default: 0
  end
end
