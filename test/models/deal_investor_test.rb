# == Schema Information
#
# Table name: deal_investors
#
#  id                   :integer          not null, primary key
#  deal_id              :integer          not null
#  investor_id          :integer          not null
#  status               :string(20)
#  primary_amount       :decimal(10, )
#  secondary_investment :decimal(10, )
#  entity_id            :integer          not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  investor_entity_id   :integer
#

require "test_helper"

class DealInvestorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
