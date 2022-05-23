class AddVestedToHolding < ActiveRecord::Migration[7.0]
  def change
    add_column :holdings, :fully_vested, :boolean, default: false
    add_column :holdings, :lapsed_quantity, :integer, default: 0
    add_column :holdings, :orig_grant_quantity, :integer, default: 0
    add_column :holdings, :sold_quantity, :integer, default: 0
    add_reference :holdings, :created_from_excercise, foreign_key: { to_table: :excercises }
  end
end
