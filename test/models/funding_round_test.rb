# == Schema Information
#
# Table name: funding_rounds
#
#  id                         :integer          not null, primary key
#  name                       :string(255)
#  total_amount_cents         :decimal(20, 2)   default("0.00")
#  currency                   :string(5)
#  pre_money_valuation_cents  :decimal(20, 2)   default("0.00")
#  post_money_valuation_cents :decimal(20, 2)   default("0.00")
#  entity_id                  :integer          not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  amount_raised_cents        :decimal(20, 2)   default("0.00")
#  status                     :string(255)      default("Open")
#  closed_on                  :date
#

require "test_helper"

class FundingRoundTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
