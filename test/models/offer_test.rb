# == Schema Information
#
# Table name: offers
#
#  id                 :integer          not null, primary key
#  user_id            :integer          not null
#  entity_id          :integer          not null
#  secondary_sale_id  :integer          not null
#  quantity           :integer          default("0")
#  percentage         :decimal(10, )    default("0")
#  notes              :text(65535)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  holding_id         :integer          not null
#  approved           :boolean          default("0")
#  granted_by_user_id :integer
#  investor_id        :integer          not null
#  offer_type         :string(15)
#

require "test_helper"

class OfferTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
