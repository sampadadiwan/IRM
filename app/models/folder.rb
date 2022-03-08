# == Schema Information
#
# Table name: folders
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  parent_folder_id :integer
#  full_path        :text(65535)
#  level            :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  entity_id        :integer          not null
#  documents_count  :integer          default("0"), not null
#

class Folder < ApplicationRecord
  belongs_to :parent, class_name: "Folder", foreign_key: :parent_folder_id, optional: true
  belongs_to :entity
  has_many :documents, dependent: :destroy

  before_save :update_level
  after_create :touch_root
  before_destroy :destroy_child_folders
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

  def destroy_child_folders
    Folder.where(parent_folder_id: id).find_each do |f|
      f.destroy if f.level != 0
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
