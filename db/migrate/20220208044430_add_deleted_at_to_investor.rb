class AddDeletedAtToInvestor < ActiveRecord::Migration[7.0]
  def change
    add_column :investments, :deleted_at, :datetime
  end
end
