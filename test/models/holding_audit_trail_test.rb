# == Schema Information
#
# Table name: holding_audit_trails
#
#  id         :integer          not null, primary key
#  action     :string(100)
#  parent_id  :string(50)
#  owner      :string(30)
#  quantity   :integer
#  operation  :integer
#  completed  :boolean          default("0")
#  ref_type   :string(255)      not null
#  ref_id     :integer          not null
#  comments   :text(65535)
#  entity_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "test_helper"

class HoldingAuditTrailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
