class CreateImportUploads < ActiveRecord::Migration[7.0]
  def change
    create_table :import_uploads do |t|
      t.string :name
      t.references :entity, null: false, foreign_key: true
      t.references :owner, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.string :import_type, limit: 50
      t.string :status, limit: 50
      t.text :error_text

      t.timestamps
    end
  end
end
