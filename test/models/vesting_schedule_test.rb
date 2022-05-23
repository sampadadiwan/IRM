# == Schema Information
#
# Table name: vesting_schedules
#
#  id                :integer          not null, primary key
#  months_from_grant :integer
#  vesting_percent   :integer
#  option_pool_id    :integer          not null
#  entity_id         :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require "test_helper"

class VestingScheduleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
