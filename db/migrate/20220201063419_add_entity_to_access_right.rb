class AddEntityToAccessRight < ActiveRecord::Migration[7.0]
  def change
    add_reference :access_rights, :entity, null: false, foreign_key: true
  end
end
