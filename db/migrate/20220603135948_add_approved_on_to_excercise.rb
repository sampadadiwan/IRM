class AddApprovedOnToExcercise < ActiveRecord::Migration[7.0]
  def change
    add_column :excercises, :approved_on, :date
  end
end
