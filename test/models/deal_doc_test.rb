# == Schema Information
#
# Table name: deal_docs
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  deal_id           :integer          not null
#  deal_investor_id  :integer
#  deal_activity_id  :integer
#  user_id           :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#

require "test_helper"

class DealDocTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
