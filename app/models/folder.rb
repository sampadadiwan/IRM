class Folder < ApplicationRecord
  belongs_to :parent, class_name: "Folder", foreign_key: :parent_folder_id, optional: true
  belongs_to :entity
  
  before_save :update_level

  scope :for, ->(user) { where("folders.entity_id=?", user.entity_id) }

  def update_level
    if parent
      self.level = parent.level + 1
      self.full_path = "#{parent.full_path}/#{name}"
    else
      self.full_path = "/"
    end
  end

  def self.build_tree(entity_id)
    map = {}
    tree = {}
    folders = Folder.where(entity_id: entity_id).order(parent_folder_id: :asc)
    parent = nil
    folders.each do |f|
      node = { details: f, children: {} }
      map[f.id] = node
      if parent.nil?
        tree[f.id] = node
        parent = node
      else
        parent = map[f.parent_folder_id]
        parent[:children][f.id] = node
      end
    end
    tree
  end
end
