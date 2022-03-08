class AddTrialStartDateToEntity < ActiveRecord::Migration[7.0]
  def change
    add_column :entities, :trial_end_date, :date
  end
end
