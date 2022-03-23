class AddPathIdsToFolder < ActiveRecord::Migration[7.0]
  def change
    add_column :folders, :path_ids, :string
  end
end
