# == Schema Information
#
# Table name: notes
#
#  id          :integer          not null, primary key
#  details     :text(65535)
#  entity_id   :integer
#  user_id     :integer
#  investor_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  deleted_at  :datetime
#

require "test_helper"

class NoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
