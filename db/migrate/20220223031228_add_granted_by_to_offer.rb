class AddGrantedByToOffer < ActiveRecord::Migration[7.0]
  def change
    add_column :offers, :granted_by_user_id, :integer
  end
end
