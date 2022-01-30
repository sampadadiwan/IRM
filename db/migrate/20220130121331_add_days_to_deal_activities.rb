class AddDaysToDealActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :deal_activities, :days, :integer
  end
end
