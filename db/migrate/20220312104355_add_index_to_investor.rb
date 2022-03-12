class AddIndexToInvestor < ActiveRecord::Migration[7.0]
  def change
    add_index :investors, [:investor_name, :investee_entity_id], unique: true
  end
end
