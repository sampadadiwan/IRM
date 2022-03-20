require "application_system_test_case"

class AggregateInvestmentsTest < ApplicationSystemTestCase
  setup do
    @aggregate_investment = aggregate_investments(:one)
  end

  test "visiting the index" do
    visit aggregate_investments_url
    assert_selector "h1", text: "Aggregate investments"
  end

  test "should create aggregate investment" do
    visit aggregate_investments_url
    click_on "New aggregate investment"

    fill_in "Entity", with: @aggregate_investment.entity_id
    fill_in "Equity", with: @aggregate_investment.equity
    fill_in "Full diluted percentage", with: @aggregate_investment.full_diluted_percentage
    fill_in "Funding round", with: @aggregate_investment.funding_round_id
    fill_in "Investor", with: @aggregate_investment.investor_id
    fill_in "Options", with: @aggregate_investment.options
    fill_in "Percentage", with: @aggregate_investment.percentage
    fill_in "Preferred", with: @aggregate_investment.preferred
    fill_in "Shareholder", with: @aggregate_investment.shareholder
    click_on "Create Aggregate investment"

    assert_text "Aggregate investment was successfully created"
    click_on "Back"
  end

  test "should update Aggregate investment" do
    visit aggregate_investment_url(@aggregate_investment)
    click_on "Edit this aggregate investment", match: :first

    fill_in "Entity", with: @aggregate_investment.entity_id
    fill_in "Equity", with: @aggregate_investment.equity
    fill_in "Full diluted percentage", with: @aggregate_investment.full_diluted_percentage
    fill_in "Funding round", with: @aggregate_investment.funding_round_id
    fill_in "Investor", with: @aggregate_investment.investor_id
    fill_in "Options", with: @aggregate_investment.options
    fill_in "Percentage", with: @aggregate_investment.percentage
    fill_in "Preferred", with: @aggregate_investment.preferred
    fill_in "Shareholder", with: @aggregate_investment.shareholder
    click_on "Update Aggregate investment"

    assert_text "Aggregate investment was successfully updated"
    click_on "Back"
  end

  test "should destroy Aggregate investment" do
    visit aggregate_investment_url(@aggregate_investment)
    click_on "Destroy this aggregate investment", match: :first

    assert_text "Aggregate investment was successfully destroyed"
  end
end
