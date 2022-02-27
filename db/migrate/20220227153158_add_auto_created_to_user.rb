class AddAutoCreatedToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :system_created, :boolean, default: false
  end
end
