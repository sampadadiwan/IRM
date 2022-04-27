class AddPrimaryRoleToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :primary_role, :string, limit: 20
  end
end
