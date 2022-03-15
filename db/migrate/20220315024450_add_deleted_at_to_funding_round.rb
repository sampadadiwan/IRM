class AddDeletedAtToFundingRound < ActiveRecord::Migration[7.0]
  def change
    add_column :funding_rounds, :deleted_at, :datetime
    add_index :funding_rounds, :deleted_at

  end
end
