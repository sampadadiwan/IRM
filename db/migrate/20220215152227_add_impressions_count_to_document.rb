class AddImpressionsCountToDocument < ActiveRecord::Migration[7.0]
  def change
    add_column :documents, :impressions_count, :integer, default: 0
    add_column :deal_docs, :impressions_count, :integer, default: 0
    add_column :deals, :impressions_count, :integer, default: 0
  end
end
