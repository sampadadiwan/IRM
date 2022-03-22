# == Schema Information
#
# Table name: scenarios
#
#  id          :integer          not null, primary key
#  name        :string(100)
#  entity_id   :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cloned_from :integer
#  deleted_at  :datetime
#

require "test_helper"

class ScenarioTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
