# == Schema Information
#
# Table name: deal_activities
#
#  id               :integer          not null, primary key
#  deal_id          :integer          not null
#  deal_investor_id :integer
#  by_date          :date
#  status           :string(20)
#  completed        :boolean
#  entity_id        :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  title            :string(255)
#  details          :text(65535)
#  sequence         :integer
#  days             :integer
#  deleted_at       :datetime
#  template_id      :integer
#

require "test_helper"

class DealActivityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
