class RenameCurrentRoleInUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :primary_role, :curr_role
  end
end
