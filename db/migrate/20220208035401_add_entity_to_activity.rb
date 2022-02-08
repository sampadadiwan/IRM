class AddEntityToActivity < ActiveRecord::Migration[7.0]
  def change
    change_table :activities do |t|
      t.integer :entity_id
    end
    add_index :activities, :entity_id

  end
end
