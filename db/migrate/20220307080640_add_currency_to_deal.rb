class AddCurrencyToDeal < ActiveRecord::Migration[7.0]
  def change
    add_column :deals, :currency, :string, limit: 10
    add_column :deals, :units, :string, limit: 15
  end
end
