require "application_system_test_case"

class ImportUploadsTest < ApplicationSystemTestCase
  setup do
    @import_upload = import_uploads(:one)
  end

  test "visiting the index" do
    visit import_uploads_url
    assert_selector "h1", text: "Import uploads"
  end

  test "should create import upload" do
    visit import_uploads_url
    click_on "New import upload"

    fill_in "Entity", with: @import_upload.entity_id
    fill_in "Error text", with: @import_upload.error_text
    fill_in "Import type", with: @import_upload.import_type
    fill_in "Name", with: @import_upload.name
    fill_in "Owner", with: @import_upload.owner_id
    fill_in "Owner type", with: @import_upload.owner_type
    fill_in "Status", with: @import_upload.status
    fill_in "User", with: @import_upload.user_id
    click_on "Create Import upload"

    assert_text "Import upload was successfully created"
    click_on "Back"
  end

  test "should update Import upload" do
    visit import_upload_url(@import_upload)
    click_on "Edit this import upload", match: :first

    fill_in "Entity", with: @import_upload.entity_id
    fill_in "Error text", with: @import_upload.error_text
    fill_in "Import type", with: @import_upload.import_type
    fill_in "Name", with: @import_upload.name
    fill_in "Owner", with: @import_upload.owner_id
    fill_in "Owner type", with: @import_upload.owner_type
    fill_in "Status", with: @import_upload.status
    fill_in "User", with: @import_upload.user_id
    click_on "Update Import upload"

    assert_text "Import upload was successfully updated"
    click_on "Back"
  end

  test "should destroy Import upload" do
    visit import_upload_url(@import_upload)
    click_on "Destroy this import upload", match: :first

    assert_text "Import upload was successfully destroyed"
  end
end
