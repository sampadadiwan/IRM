class Folder < ApplicationRecord
  belongs_to :parent, class_name: "Folder", foreign_key: :parent_folder_id, optional: true
  belongs_to :entity
  has_many :documents, dependent: :destroy

  before_save :update_level
  after_create :touch_root
  after_destroy :touch_root

  scope :for, ->(user) { where("folders.entity_id=?", user.entity_id).order("full_path asc") }

  def update_level
    if parent
      self.level = parent.level + 1
      self.full_path = level == 1 ? "#{parent.full_path}#{name}" : "#{parent.full_path}/#{name}"
    else
      self.level = 0
      self.full_path = "/"
    end
  end

  def touch_root
    Folder.where(entity_id: entity_id, level: 0).first.touch
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
