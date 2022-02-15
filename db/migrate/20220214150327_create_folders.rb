class CreateFolders < ActiveRecord::Migration[7.0]
  def change
    create_table :folders do |t|
      t.string :name, limit: 100
      t.integer :parent_folder_id
      t.text :full_path
      t.integer :level

      t.timestamps
    end
    add_index :folders, :parent_folder_id
  end
end
