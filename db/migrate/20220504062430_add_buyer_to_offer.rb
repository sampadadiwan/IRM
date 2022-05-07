class AddBuyerToOffer < ActiveRecord::Migration[7.0]
  def change
    add_column :offers, :buyer_confirmation, :string, limit: 10
    add_column :offers, :buyer_notes, :text
    add_reference :offers, :buyer, foreign_key: { to_table: :entities }
  end
end
