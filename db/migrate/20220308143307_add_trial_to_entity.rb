class AddTrialToEntity < ActiveRecord::Migration[7.0]
  def change
    add_column :entities, :trial, :boolean, default: false
  end
end
