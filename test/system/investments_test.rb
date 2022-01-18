require "application_system_test_case"

class InvestmentsTest < ApplicationSystemTestCase
  setup do
    @investment = investments(:one)
  end

  test "visiting the index" do
    visit investments_url
    assert_selector "h1", text: "Investments"
  end

  test "should create investment" do
    visit investments_url
    click_on "New investment"

    fill_in "Current value", with: @investment.current_value
    fill_in "Intial value", with: @investment.intial_value
    fill_in "Investee company", with: @investment.investee_company_id
    fill_in "Investment instrument", with: @investment.investment_instrument
    fill_in "Investment type", with: @investment.investment_type
    fill_in "Investor company", with: @investment.investor_company_id
    fill_in "Investor type", with: @investment.investor_type
    fill_in "Quantity", with: @investment.quantity
    click_on "Create Investment"

    assert_text "Investment was successfully created"
    click_on "Back"
  end

  test "should update Investment" do
    visit investment_url(@investment)
    click_on "Edit this investment", match: :first

    fill_in "Current value", with: @investment.current_value
    fill_in "Intial value", with: @investment.intial_value
    fill_in "Investee company", with: @investment.investee_company_id
    fill_in "Investment instrument", with: @investment.investment_instrument
    fill_in "Investment type", with: @investment.investment_type
    fill_in "Investor company", with: @investment.investor_company_id
    fill_in "Investor type", with: @investment.investor_type
    fill_in "Quantity", with: @investment.quantity
    click_on "Update Investment"

    assert_text "Investment was successfully updated"
    click_on "Back"
  end

  test "should destroy Investment" do
    visit investment_url(@investment)
    click_on "Destroy this investment", match: :first

    assert_text "Investment was successfully destroyed"
  end
end
