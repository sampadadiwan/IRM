class AddEnableWhatsappToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :whatsapp_enabled, :boolean, default: false
  end
end
