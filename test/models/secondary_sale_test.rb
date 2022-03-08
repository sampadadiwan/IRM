# == Schema Information
#
# Table name: secondary_sales
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  entity_id              :integer          not null
#  start_date             :date
#  end_date               :date
#  percent_allowed        :integer          default("0")
#  min_price              :decimal(5, 2)
#  max_price              :decimal(5, 2)
#  active                 :boolean          default("1")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  total_offered_quantity :integer          default("0")
#  visible_externally     :boolean          default("0")
#

require "test_helper"

class SecondarySaleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
