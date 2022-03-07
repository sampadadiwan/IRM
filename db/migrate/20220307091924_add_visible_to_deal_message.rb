class AddVisibleToDealMessage < ActiveRecord::Migration[7.0]
  def change
    add_column :deal_messages, :not_msg, :boolean, default: false
  end
end
