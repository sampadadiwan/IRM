class CreateDocVisibilities < ActiveRecord::Migration[7.0]
  def change
    create_table :doc_visibilities do |t|
      t.integer :document_id
      t.string :visiblity_type, limit: 30
      t.string :to

      t.timestamps
    end
    add_index :doc_visibilities, :document_id
  end
end
