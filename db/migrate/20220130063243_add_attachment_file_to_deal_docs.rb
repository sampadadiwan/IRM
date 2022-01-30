class AddAttachmentFileToDealDocs < ActiveRecord::Migration[7.0]
  def self.up
    change_table :deal_docs do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :deal_docs, :file
  end
end
