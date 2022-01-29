require "application_system_test_case"

class DealInvestorsTest < ApplicationSystemTestCase
  setup do
    @deal_investor = deal_investors(:one)
  end

  test "visiting the index" do
    visit deal_investors_url
    assert_selector "h1", text: "Deal investors"
  end

  test "should create deal investor" do
    visit deal_investors_url
    click_on "New deal investor"

    fill_in "Deal", with: @deal_investor.deal_id
    fill_in "Entity", with: @deal_investor.entity_id
    fill_in "Investor", with: @deal_investor.investor_id
    fill_in "Primary amount", with: @deal_investor.primary_amount
    fill_in "Secondary investment", with: @deal_investor.secondary_investment
    fill_in "Status", with: @deal_investor.status
    click_on "Create Deal investor"

    assert_text "Deal investor was successfully created"
    click_on "Back"
  end

  test "should update Deal investor" do
    visit deal_investor_url(@deal_investor)
    click_on "Edit this deal investor", match: :first

    fill_in "Deal", with: @deal_investor.deal_id
    fill_in "Entity", with: @deal_investor.entity_id
    fill_in "Investor", with: @deal_investor.investor_id
    fill_in "Primary amount", with: @deal_investor.primary_amount
    fill_in "Secondary investment", with: @deal_investor.secondary_investment
    fill_in "Status", with: @deal_investor.status
    click_on "Update Deal investor"

    assert_text "Deal investor was successfully updated"
    click_on "Back"
  end

  test "should destroy Deal investor" do
    visit deal_investor_url(@deal_investor)
    click_on "Destroy this deal investor", match: :first

    assert_text "Deal investor was successfully destroyed"
  end
end
