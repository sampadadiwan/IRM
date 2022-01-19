require "application_system_test_case"

class InvestorsTest < ApplicationSystemTestCase
  setup do
    @investor = investors(:one)
  end

  test "visiting the index" do
    visit investors_url
    assert_selector "h1", text: "Investors"
  end

  test "should create investor" do
    visit investors_url
    click_on "New investor"

    fill_in "Category", with: @investor.category
    fill_in "Investee company", with: @investor.investee_company_id
    fill_in "Investor company", with: @investor.investor_company_id
    click_on "Create Investor"

    assert_text "Investor was successfully created"
    click_on "Back"
  end

  test "should update Investor" do
    visit investor_url(@investor)
    click_on "Edit this investor", match: :first

    fill_in "Category", with: @investor.category
    fill_in "Investee company", with: @investor.investee_company_id
    fill_in "Investor company", with: @investor.investor_company_id
    click_on "Update Investor"

    assert_text "Investor was successfully updated"
    click_on "Back"
  end

  test "should destroy Investor" do
    visit investor_url(@investor)
    click_on "Destroy this investor", match: :first

    assert_text "Investor was successfully destroyed"
  end
end
