# == Schema Information
#
# Table name: deal_messages
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  deal_investor_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  is_task          :boolean          default("0")
#  task_done        :boolean          default("0")
#

require "test_helper"

class DealMessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
