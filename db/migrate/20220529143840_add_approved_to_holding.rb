class AddApprovedToHolding < ActiveRecord::Migration[7.0]
  def change
    add_column :holdings, :approved, :boolean, default: false
    add_column :holdings, :approved_by_user_id, :bigint
  end
end
