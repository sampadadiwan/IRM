class AddGrantDateToHolding < ActiveRecord::Migration[7.0]
  def change
    add_column :holdings, :grant_date, :date
  end
end
