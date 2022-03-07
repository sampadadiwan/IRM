class AddCurrencyToEntity < ActiveRecord::Migration[7.0]
  def change
    add_column :entities, :currency, :string, limit: 10
    add_column :entities, :units, :string, limit: 15
  end
end
