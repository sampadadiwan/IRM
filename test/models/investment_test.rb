# == Schema Information
#
# Table name: investments
#
#  id                    :integer          not null, primary key
#  investment_type       :string(20)
#  investor_id           :integer
#  investor_type         :string(20)
#  investee_entity_id    :integer
#  status                :string(20)
#  investment_instrument :string(50)
#  quantity              :integer
#  initial_value         :decimal(20, )
#  current_value         :decimal(20, )
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  category              :string(25)
#  deleted_at            :datetime
#  percentage_holding    :decimal(5, 2)
#

require "test_helper"

class InvestmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
