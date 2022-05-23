# == Schema Information
#
# Table name: interests
#
#  id                      :integer          not null, primary key
#  offer_entity_id         :integer
#  quantity                :integer
#  price                   :decimal(10, )
#  user_id                 :integer          not null
#  interest_entity_id      :integer
#  secondary_sale_id       :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  short_listed            :boolean          default("0")
#  escrow_deposited        :boolean          default("0")
#  final_price             :decimal(10, 2)   default("0.00")
#  amount_cents            :decimal(20, 2)   default("0.00")
#  allocation_quantity     :integer          default("0")
#  allocation_amount_cents :decimal(20, 2)   default("0.00")
#  allocation_percentage   :decimal(5, 2)    default("0.00")
#

require "test_helper"

class InterestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
