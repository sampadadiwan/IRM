class AddSpvToInvestment < ActiveRecord::Migration[7.0]
  def change
    add_column :investments, :spv, :string, limit: 50
  end
end
