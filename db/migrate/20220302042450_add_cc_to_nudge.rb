class AddCcToNudge < ActiveRecord::Migration[7.0]
  def change
    add_column :nudges, :cc, :text
    add_column :nudges, :bcc, :text
  end
end
