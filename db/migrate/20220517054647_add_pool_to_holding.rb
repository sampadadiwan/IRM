class AddPoolToHolding < ActiveRecord::Migration[7.0]
  def change
    add_reference :holdings, :esop_pool, null: true, foreign_key: true
    add_column :holdings, :excercised_quantity, :integer, default: 0
  end
end
