class AddEntityToDocument < ActiveRecord::Migration[7.0]
  def change
    add_reference :documents, :entity, null: false
  end
end
