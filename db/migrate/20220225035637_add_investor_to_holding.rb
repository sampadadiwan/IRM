class AddInvestorToHolding < ActiveRecord::Migration[7.0]
  def change
    add_reference :holdings, :investor, null: false, foreign_key: true
    add_column :holdings, :holding_type, :string, null: false, limit: 15
  end
end
