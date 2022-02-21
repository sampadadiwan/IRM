class AddArchivedToDeal < ActiveRecord::Migration[7.0]
  def change
    add_column :deals, :archived, :boolean, default: false
  end
end
