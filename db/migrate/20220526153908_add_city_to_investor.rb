class AddCityToInvestor < ActiveRecord::Migration[7.0]
  def change
    add_column :investors, :city, :string, limit: 50
  end
end
