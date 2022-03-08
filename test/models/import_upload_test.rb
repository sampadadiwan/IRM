# == Schema Information
#
# Table name: import_uploads
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  entity_id   :integer          not null
#  owner_type  :string(255)      not null
#  owner_id    :integer          not null
#  user_id     :integer          not null
#  import_type :string(50)
#  status      :string(50)
#  error_text  :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require "test_helper"

class ImportUploadTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
