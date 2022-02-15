class AddDocumentCountToFolders < ActiveRecord::Migration[7.0]
  def self.up
    add_column :folders, :documents_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :folders, :documents_count
  end
end
