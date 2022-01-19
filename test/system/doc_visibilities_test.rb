require "application_system_test_case"

class DocVisibilitiesTest < ApplicationSystemTestCase
  setup do
    @doc_visibility = doc_visibilities(:one)
  end

  test "visiting the index" do
    visit doc_visibilities_url
    assert_selector "h1", text: "Doc visibilities"
  end

  test "should create doc visibility" do
    visit doc_visibilities_url
    click_on "New doc visibility"

    fill_in "Document", with: @doc_visibility.document_id
    fill_in "To", with: @doc_visibility.to
    fill_in "Visiblity type", with: @doc_visibility.visiblity_type
    click_on "Create Doc visibility"

    assert_text "Doc visibility was successfully created"
    click_on "Back"
  end

  test "should update Doc visibility" do
    visit doc_visibility_url(@doc_visibility)
    click_on "Edit this doc visibility", match: :first

    fill_in "Document", with: @doc_visibility.document_id
    fill_in "To", with: @doc_visibility.to
    fill_in "Visiblity type", with: @doc_visibility.visiblity_type
    click_on "Update Doc visibility"

    assert_text "Doc visibility was successfully updated"
    click_on "Back"
  end

  test "should destroy Doc visibility" do
    visit doc_visibility_url(@doc_visibility)
    click_on "Destroy this doc visibility", match: :first

    assert_text "Doc visibility was successfully destroyed"
  end
end
