class AddDeletedAtToScenario < ActiveRecord::Migration[7.0]
  def change
    add_column :scenarios, :deleted_at, :datetime
    add_index :scenarios, :deleted_at
  end
end
