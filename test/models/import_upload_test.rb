# == Schema Information
#
# Table name: import_uploads
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  entity_id           :integer          not null
#  owner_type          :string(255)      not null
#  owner_id            :integer          not null
#  user_id             :integer          not null
#  import_type         :string(50)
#  status              :text(65535)
#  error_text          :text(65535)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  total_rows_count    :integer          default("0")
#  processed_row_count :integer          default("0")
#  failed_row_count    :integer          default("0")
#

require "test_helper"

class ImportUploadTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
