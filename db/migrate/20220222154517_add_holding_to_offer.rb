class AddHoldingToOffer < ActiveRecord::Migration[7.0]
  def change
    add_reference :offers, :holding, null: false, foreign_key: true
  end
end
