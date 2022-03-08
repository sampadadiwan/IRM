class AddTemplateIdToDealActivity < ActiveRecord::Migration[7.0]
  def change
    add_column :deal_activities, :template_id, :integer
  end
end
