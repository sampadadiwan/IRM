class AddTitleToDealActivity < ActiveRecord::Migration[7.0]
  def change
    add_column :deal_activities, :title, :string
    add_column :deal_activities, :details, :text
  end
end
