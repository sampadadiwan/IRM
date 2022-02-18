# == Schema Information
#
# Table name: investors
#
#  id                               :integer          not null, primary key
#  investor_entity_id               :integer
#  investee_entity_id               :integer
#  category                         :string(50)
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  investor_name                    :string(255)
#  deleted_at                       :datetime
#  last_interaction_date            :date
#  investor_accesses_count          :integer          default("0")
#  unapproved_investor_access_count :integer          default("0")
#

require "test_helper"

class InvestorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
