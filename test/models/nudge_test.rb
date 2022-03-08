# == Schema Information
#
# Table name: nudges
#
#  id         :integer          not null, primary key
#  to         :text(65535)
#  subject    :text(65535)
#  msg_body   :text(65535)
#  user_id    :integer          not null
#  entity_id  :integer          not null
#  item_type  :string(255)
#  item_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  cc         :text(65535)
#  bcc        :text(65535)
#

require "test_helper"

class NudgeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
