class CreateScenarios < ActiveRecord::Migration[7.0]
  def change
    create_table :scenarios do |t|
      t.string :name, limit: 100
      t.references :entity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
