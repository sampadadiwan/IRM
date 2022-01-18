class CreateInvestments < ActiveRecord::Migration[7.0]
  def change
    create_table :investments do |t|
      t.string :investment_type, limit: 20
      t.integer :investor_company_id
      t.integer :investee_company_id
      t.string :investor_type, limit: 20
      t.string :investment_instrument, limit: 50
      t.integer :quantity
      t.decimal :intial_value
      t.decimal :current_value

      t.timestamps
    end
    add_index :investments, :investor_company_id
    add_index :investments, :investee_company_id
  end
end
