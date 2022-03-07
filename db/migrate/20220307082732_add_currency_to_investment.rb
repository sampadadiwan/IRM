class AddCurrencyToInvestment < ActiveRecord::Migration[7.0]
  def change
    add_column :investments, :currency, :string, limit: 10
    add_column :investments, :units, :string, limit: 15
  end
end
