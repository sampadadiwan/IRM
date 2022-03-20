class AddAggregateToEntity < ActiveRecord::Migration[7.0]
  def change
    add_column :entities, :equity, :integer, default: 0
    add_column :entities, :preferred, :integer, default: 0
    add_column :entities, :option, :integer, default: 0
  end
end
