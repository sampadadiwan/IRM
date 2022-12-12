class AddVerifiedByToInvestorKyc < ActiveRecord::Migration[7.0]
  def change
    add_reference :investor_kycs, :verified_by, null: true, foreign_key: {to_table: :users}
  end
end
