class AddInvestorsCountInvestmentsCountDealsCountDealInvestorsCountDocumentsCountToEntities < ActiveRecord::Migration[7.0]
  def self.up
    add_column :entities, :investors_count, :integer, null: false, default: 0

    add_column :entities, :investments_count, :integer, null: false, default: 0

    add_column :entities, :deals_count, :integer, null: false, default: 0

    add_column :entities, :deal_investors_count, :integer, null: false, default: 0

    add_column :entities, :documents_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :entities, :investors_count

    remove_column :entities, :investments_count

    remove_column :entities, :deals_count

    remove_column :entities, :deal_investors_count

    remove_column :entities, :documents_count
  end
end
