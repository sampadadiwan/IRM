class AddInvestorFlagToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_investor, :boolean
    add_column :users, :is_startup, :boolean
  end
end
