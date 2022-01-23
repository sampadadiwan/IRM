require "application_system_test_case"

class InvestorAccessesTest < ApplicationSystemTestCase
  setup do
    @investor_access = investor_accesses(:one)
  end

  test "visiting the index" do
    visit investor_accesses_url
    assert_selector "h1", text: "Investor accesses"
  end

  test "should create investor access" do
    visit investor_accesses_url
    click_on "New investor access"

    fill_in "Access type", with: @investor_access.access_type
    fill_in "Email", with: @investor_access.email
    fill_in "Granted by", with: @investor_access.granted_by
    fill_in "Investor", with: @investor_access.investor_id
    click_on "Create Investor access"

    assert_text "Investor access was successfully created"
    click_on "Back"
  end

  test "should update Investor access" do
    visit investor_access_url(@investor_access)
    click_on "Edit this investor access", match: :first

    fill_in "Access type", with: @investor_access.access_type
    fill_in "Email", with: @investor_access.email
    fill_in "Granted by", with: @investor_access.granted_by
    fill_in "Investor", with: @investor_access.investor_id
    click_on "Update Investor access"

    assert_text "Investor access was successfully updated"
    click_on "Back"
  end

  test "should destroy Investor access" do
    visit investor_access_url(@investor_access)
    click_on "Destroy this investor access", match: :first

    assert_text "Investor access was successfully destroyed"
  end
end
