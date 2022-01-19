class AddCategoryToInvestment < ActiveRecord::Migration[7.0]
  def change
    add_column :investments, :category, :string, limit: 25
  end
end
