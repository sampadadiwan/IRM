# == Schema Information
#
# Table name: holdings
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  entity_id             :integer          not null
#  quantity              :integer          default("0")
#  value_cents           :decimal(20, 2)   default("0.00")
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  investment_instrument :string(100)
#  investor_id           :integer          not null
#  holding_type          :string(15)       not null
#  investment_id         :integer          not null
#  price_cents           :decimal(20, 2)   default("0.00")
#  funding_round_id      :integer          not null
#

require "test_helper"

class HoldingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
