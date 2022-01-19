class CreateInvestors < ActiveRecord::Migration[7.0]
  def change
    create_table :investors do |t|
      t.integer :investor_company_id
      t.integer :investee_company_id
      t.string :category, limit: 50

      t.timestamps
    end
    add_index :investors, :investor_company_id
    add_index :investors, :investee_company_id
  end
end
