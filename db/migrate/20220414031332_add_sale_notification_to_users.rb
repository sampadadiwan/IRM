class AddSaleNotificationToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :sale_notification, :boolean, default: false
  end
end
