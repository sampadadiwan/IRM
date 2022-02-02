class AddCategoryToAccessRight < ActiveRecord::Migration[7.0]
  def change
    add_column :access_rights, :access_to_category, :string, limit: 20
  end
end
