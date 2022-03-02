class AddFeatureFlagsToEntity < ActiveRecord::Migration[7.0]
  def change
    add_column :entities, :enable_documents, :boolean, default: false
    add_column :entities, :enable_deals, :boolean, default: false
    add_column :entities, :enable_investments, :boolean, default: false
    add_column :entities, :enable_holdings, :boolean, default: false
    add_column :entities, :enable_secondary_sale, :boolean, default: false
  end
end
