class AddTaskToDealMessage < ActiveRecord::Migration[7.0]
  def change
    add_column :deal_messages, :is_task, :boolean, default: false
  end
end
