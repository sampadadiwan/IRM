require "application_system_test_case"

class InterestsTest < ApplicationSystemTestCase
  setup do
    @interest = interests(:one)
  end

  test "visiting the index" do
    visit interests_url
    assert_selector "h1", text: "Interests"
  end

  test "should create interest" do
    visit interests_url
    click_on "New interest"

    fill_in "Company", with: @interest.company_id
    fill_in "Price per share", with: @interest.price_per_share
    fill_in "Share type", with: @interest.share_type
    fill_in "Shares max", with: @interest.shares_max
    fill_in "Shares min", with: @interest.shares_min
    fill_in "Side", with: @interest.side
    fill_in "User", with: @interest.user_id
    click_on "Create Interest"

    assert_text "Interest was successfully created"
    click_on "Back"
  end

  test "should update Interest" do
    visit interest_url(@interest)
    click_on "Edit this interest", match: :first

    fill_in "Company", with: @interest.company_id
    fill_in "Price per share", with: @interest.price_per_share
    fill_in "Share type", with: @interest.share_type
    fill_in "Shares max", with: @interest.shares_max
    fill_in "Shares min", with: @interest.shares_min
    fill_in "Side", with: @interest.side
    fill_in "User", with: @interest.user_id
    click_on "Update Interest"

    assert_text "Interest was successfully updated"
    click_on "Back"
  end

  test "should destroy Interest" do
    visit interest_url(@interest)
    click_on "Destroy this interest", match: :first

    assert_text "Interest was successfully destroyed"
  end
end
