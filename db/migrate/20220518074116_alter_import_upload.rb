class AlterImportUpload < ActiveRecord::Migration[7.0]
  def change
    change_column :import_uploads, :status, :string, :limit => 200
  end
end
