# == Schema Information
#
# Table name: folders
#
#  id               :integer          not null, primary key
#  name             :string(100)
#  parent_folder_id :integer
#  full_path        :text(65535)
#  level            :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  entity_id        :integer          not null
#  documents_count  :integer          default("0"), not null
#

require "test_helper"

class FolderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
