class AddTaxToOffer < ActiveRecord::Migration[7.0]
  def change
    add_column :offers, :first_name, :string
    add_column :offers, :middle_name, :string
    add_column :offers, :last_name, :string
    add_column :offers, :PAN, :string, limit: 15
    add_column :offers, :address, :text
    add_column :offers, :bank_account_number, :string, limit: 40
    add_column :offers, :bank_name, :string, limit: 50
    add_column :offers, :bank_routing_info, :text
  end
end
