require "application_system_test_case"

class FundingRoundsTest < ApplicationSystemTestCase
  setup do
    @funding_round = funding_rounds(:one)
  end

  test "visiting the index" do
    visit funding_rounds_url
    assert_selector "h1", text: "Funding rounds"
  end

  test "should create funding round" do
    visit funding_rounds_url
    click_on "New funding round"

    fill_in "Currency", with: @funding_round.currency
    fill_in "Entity", with: @funding_round.entity_id
    fill_in "Name", with: @funding_round.name
    fill_in "Post money valuation cents", with: @funding_round.post_money_valuation_cents
    fill_in "Pre money valuation cents", with: @funding_round.pre_money_valuation_cents
    fill_in "Total amount cents", with: @funding_round.total_amount_cents
    click_on "Create Funding round"

    assert_text "Funding round was successfully created"
    click_on "Back"
  end

  test "should update Funding round" do
    visit funding_round_url(@funding_round)
    click_on "Edit this funding round", match: :first

    fill_in "Currency", with: @funding_round.currency
    fill_in "Entity", with: @funding_round.entity_id
    fill_in "Name", with: @funding_round.name
    fill_in "Post money valuation cents", with: @funding_round.post_money_valuation_cents
    fill_in "Pre money valuation cents", with: @funding_round.pre_money_valuation_cents
    fill_in "Total amount cents", with: @funding_round.total_amount_cents
    click_on "Update Funding round"

    assert_text "Funding round was successfully updated"
    click_on "Back"
  end

  test "should destroy Funding round" do
    visit funding_round_url(@funding_round)
    click_on "Destroy this funding round", match: :first

    assert_text "Funding round was successfully destroyed"
  end
end
