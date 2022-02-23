class AddApprovedToOffer < ActiveRecord::Migration[7.0]
  def change
    add_column :offers, :approved, :boolean, default: false
  end
end
