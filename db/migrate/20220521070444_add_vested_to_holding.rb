class AddVestedToHolding < ActiveRecord::Migration[7.0]
  def change
    add_column :holdings, :fully_vested, :boolean, default: false
  end
end
