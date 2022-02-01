class CreateAccessRights < ActiveRecord::Migration[7.0]
  def change
    create_table :access_rights do |t|
      t.references :owner, polymorphic: true, null: false
      t.string :access_to, limit: 30
      t.integer :access_to_investor_id
      t.string :access_type, limit: 15
      t.string :metadata

      t.timestamps
    end
  end
end
