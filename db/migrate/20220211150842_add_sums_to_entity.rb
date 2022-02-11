class AddSumsToEntity < ActiveRecord::Migration[7.0]
  def change
    add_column :entities, :total_investments, :decimal, precision: 20
  end
end
