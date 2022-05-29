class AddMetaDataToImportUpload < ActiveRecord::Migration[7.0]
  def change
    add_column :import_uploads, :total_rows_count, :integer, default: 0
    add_column :import_uploads, :processed_row_count, :integer, default: 0
    add_column :import_uploads, :failed_row_count, :integer, default: 0
  end
end
