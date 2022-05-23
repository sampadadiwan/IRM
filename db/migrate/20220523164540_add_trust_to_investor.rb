class AddTrustToInvestor < ActiveRecord::Migration[7.0]
  def change
    add_column :investors, :is_trust, :boolean, default: false
  end
end
