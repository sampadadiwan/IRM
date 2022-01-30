class AddSequenceToDealActivity < ActiveRecord::Migration[7.0]
  def change
    add_column :deal_activities, :sequence, :integer
  end
end
