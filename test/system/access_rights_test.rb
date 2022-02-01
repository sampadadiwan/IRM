require "application_system_test_case"

class AccessRightsTest < ApplicationSystemTestCase
  setup do
    @access_right = access_rights(:one)
  end

  test "visiting the index" do
    visit access_rights_url
    assert_selector "h1", text: "Access rights"
  end

  test "should create access right" do
    visit access_rights_url
    click_on "New access right"

    fill_in "Access to", with: @access_right.access_to
    fill_in "Access to investor", with: @access_right.access_to_investor_id
    fill_in "Access type", with: @access_right.access_type
    fill_in "Metadata", with: @access_right.metadata
    fill_in "Owner", with: @access_right.owner_id
    fill_in "Owner type", with: @access_right.owner_type
    click_on "Create Access right"

    assert_text "Access right was successfully created"
    click_on "Back"
  end

  test "should update Access right" do
    visit access_right_url(@access_right)
    click_on "Edit this access right", match: :first

    fill_in "Access to", with: @access_right.access_to
    fill_in "Access to investor", with: @access_right.access_to_investor_id
    fill_in "Access type", with: @access_right.access_type
    fill_in "Metadata", with: @access_right.metadata
    fill_in "Owner", with: @access_right.owner_id
    fill_in "Owner type", with: @access_right.owner_type
    click_on "Update Access right"

    assert_text "Access right was successfully updated"
    click_on "Back"
  end

  test "should destroy Access right" do
    visit access_right_url(@access_right)
    click_on "Destroy this access right", match: :first

    assert_text "Access right was successfully destroyed"
  end
end
