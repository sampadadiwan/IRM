class AddResponseToTask < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :response, :text
  end
end
