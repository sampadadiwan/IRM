class CreateNotes < ActiveRecord::Migration[7.0]
  def change
    create_table :notes do |t|
      t.text :details
      t.integer :entity_id
      t.integer :user_id
      t.integer :investor_id

      t.timestamps
    end
    add_index :notes, :entity_id
    add_index :notes, :user_id
    add_index :notes, :investor_id
  end
end
