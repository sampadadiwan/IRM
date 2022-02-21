class AddInstrumentToHolding < ActiveRecord::Migration[7.0]
  def change
    add_column :holdings, :investment_instrument, :string, limit: 100
  end
end
