class AddMessageCountToDealInvestor < ActiveRecord::Migration[7.0]
  def change
    add_column :deal_investors, :unread_messages_investor, :integer, default: 0
    add_column :deal_investors, :unread_messages_investee, :integer, default: 0
    add_column :deal_investors, :todays_messages_investor, :integer, default: 0
    add_column :deal_investors, :todays_messages_investee, :integer, default: 0
  end
end
