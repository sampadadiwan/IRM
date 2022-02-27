require "test_helper"

class ImportUploadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @import_upload = import_uploads(:one)
  end

  test "should get index" do
    get import_uploads_url
    assert_response :success
  end

  test "should get new" do
    get new_import_upload_url
    assert_response :success
  end

  test "should create import_upload" do
    assert_difference("ImportUpload.count") do
      post import_uploads_url, params: { import_upload: { entity_id: @import_upload.entity_id, error_text: @import_upload.error_text, import_type: @import_upload.import_type, name: @import_upload.name, owner_id: @import_upload.owner_id, owner_type: @import_upload.owner_type, status: @import_upload.status, user_id: @import_upload.user_id } }
    end

    assert_redirected_to import_upload_url(ImportUpload.last)
  end

  test "should show import_upload" do
    get import_upload_url(@import_upload)
    assert_response :success
  end

  test "should get edit" do
    get edit_import_upload_url(@import_upload)
    assert_response :success
  end

  test "should update import_upload" do
    patch import_upload_url(@import_upload), params: { import_upload: { entity_id: @import_upload.entity_id, error_text: @import_upload.error_text, import_type: @import_upload.import_type, name: @import_upload.name, owner_id: @import_upload.owner_id, owner_type: @import_upload.owner_type, status: @import_upload.status, user_id: @import_upload.user_id } }
    assert_redirected_to import_upload_url(@import_upload)
  end

  test "should destroy import_upload" do
    assert_difference("ImportUpload.count", -1) do
      delete import_upload_url(@import_upload)
    end

    assert_redirected_to import_uploads_url
  end
end
