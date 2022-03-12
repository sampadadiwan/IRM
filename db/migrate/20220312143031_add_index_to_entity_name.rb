class AddIndexToEntityName < ActiveRecord::Migration[7.0]
  def change
    add_index :entities, :name, unique: true
  end
end
