# == Schema Information
#
# Table name: deal_investors
#
#  id                       :integer          not null, primary key
#  deal_id                  :integer          not null
#  investor_id              :integer          not null
#  status                   :string(20)
#  primary_amount           :decimal(10, )
#  secondary_investment     :decimal(10, )
#  entity_id                :integer          not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  investor_entity_id       :integer
#  deleted_at               :datetime
#  impressions_count        :integer
#  unread_messages_investor :integer          default("0")
#  unread_messages_investee :integer          default("0")
#  todays_messages_investor :integer          default("0")
#  todays_messages_investee :integer          default("0")
#  pre_money_valuation      :decimal(20, 2)   default("0.00")
#  company_advisor          :string(100)
#  investor_advisor         :string(100)
#

require "test_helper"

class DealInvestorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
