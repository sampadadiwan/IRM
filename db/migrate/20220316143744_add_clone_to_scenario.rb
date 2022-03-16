class AddCloneToScenario < ActiveRecord::Migration[7.0]
  def change
    add_column :scenarios, :cloned_from, :integer
  end
end
