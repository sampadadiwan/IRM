class AddInvestorToOffer < ActiveRecord::Migration[7.0]
  def change
    add_reference :offers, :investor, null: false, foreign_key: true
    add_column :offers, :offer_type, :string, limit: 15
  end
end
