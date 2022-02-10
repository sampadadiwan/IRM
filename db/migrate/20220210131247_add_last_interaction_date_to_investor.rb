class AddLastInteractionDateToInvestor < ActiveRecord::Migration[7.0]
  def change
    add_column :investors, :last_interaction_date, :date
  end
end
