class AddDilutedToInvestment < ActiveRecord::Migration[7.0]
  def change
    add_column :investments, :diluted_quantity, :integer, default:0
    add_column :investments, :diluted_percentage, :decimal, precision: 5, scale: 2, default:0
    add_column :investments, :price, :decimal, default:0
    add_column :investments, :amount, :decimal, precision: 20, scale: 2, default:0
  end
end
