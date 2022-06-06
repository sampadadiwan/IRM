class AddPercentInProgressToScenario < ActiveRecord::Migration[7.0]
  def change
    add_column :scenarios, :percentage_in_progress, :boolean, default: false
    add_column :scenarios, :lock_version, :integer, default: 0
  end
end
