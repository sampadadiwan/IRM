class CreateVestingSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :vesting_schedules do |t|
      t.integer :months_from_grant
      t.integer :vesting_percent
      t.references :esop_pool, null: false, foreign_key: true
      t.references :entity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
