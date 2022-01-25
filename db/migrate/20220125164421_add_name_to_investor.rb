class AddNameToInvestor < ActiveRecord::Migration[7.0]
  def change
    add_column :investors, :investor_name, :string
  end
end
