class AddSettingsToEntity < ActiveRecord::Migration[7.0]
  def change
    add_column :entities, :investor_categories, :string
    add_column :entities, :investment_types, :string
    add_column :entities, :instrument_types, :string
  end
end
