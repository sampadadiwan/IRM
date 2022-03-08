# == Schema Information
#
# Table name: investments
#
#  id                    :integer          not null, primary key
#  investment_type       :string(100)
#  investor_id           :integer
#  investor_type         :string(100)
#  investee_entity_id    :integer
#  status                :string(20)
#  investment_instrument :string(100)
#  quantity              :integer          default("0")
#  initial_value         :decimal(20, 2)   default("0.00")
#  current_value         :decimal(20, 2)   default("0.00")
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  category              :string(100)
#  deleted_at            :datetime
#  percentage_holding    :decimal(5, 2)
#  employee_holdings     :boolean          default("0")
#  diluted_quantity      :integer          default("0")
#  diluted_percentage    :decimal(5, 2)    default("0.00")
#  price                 :decimal(10, )    default("0")
#  amount                :decimal(20, 2)   default("0.00")
#  currency              :string(10)
#  units                 :string(15)
#

require "test_helper"

class InvestmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
