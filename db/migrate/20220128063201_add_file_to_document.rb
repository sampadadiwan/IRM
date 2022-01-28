class AddFileToDocument < ActiveRecord::Migration[7.0]
  def change
        add_attachment :documents, :file
  end
end
