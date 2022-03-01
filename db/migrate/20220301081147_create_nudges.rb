class CreateNudges < ActiveRecord::Migration[7.0]
  def change
    create_table :nudges do |t|
      t.text :to
      t.text :subject
      t.text :msg_body
      t.references :user, null: false, foreign_key: true
      t.references :entity, null: false, foreign_key: true
      t.references :item, polymorphic: true

      t.timestamps
    end
  end
end
