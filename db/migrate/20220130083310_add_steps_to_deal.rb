class AddStepsToDeal < ActiveRecord::Migration[7.0]
  def change
    add_column :deals, :activity_list, :text
  end
end
