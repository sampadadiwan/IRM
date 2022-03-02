class AddShortlistToInterest < ActiveRecord::Migration[7.0]
  def change
    add_column :interests, :short_listed, :boolean, default: false
    add_column :interests, :escrow_deposited, :boolean, default: false
  end
end
