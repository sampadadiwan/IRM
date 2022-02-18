# == Schema Information
#
# Table name: deals
#
#  id                :integer          not null, primary key
#  entity_id         :integer          not null
#  name              :string(100)
#  amount            :decimal(10, )
#  status            :string(20)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  activity_list     :text(65535)
#  start_date        :date
#  end_date          :date
#  deleted_at        :datetime
#  impressions_count :integer          default("0")
#

require "test_helper"

class DealTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
