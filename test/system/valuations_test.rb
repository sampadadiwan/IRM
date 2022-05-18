require "application_system_test_case"

class ValuationsTest < ApplicationSystemTestCase
  setup do
    @valuation = valuations(:one)
  end

  test "visiting the index" do
    visit valuations_url
    assert_selector "h1", text: "Valuations"
  end

  test "should create valuation" do
    visit valuations_url
    click_on "New valuation"

    fill_in "Entity", with: @valuation.entity_id
    fill_in "Per share value", with: @valuation.per_share_value
    fill_in "Pre money valuation", with: @valuation.pre_money_valuation
    fill_in "Valuation date", with: @valuation.valuation_date
    click_on "Create Valuation"

    assert_text "Valuation was successfully created"
    click_on "Back"
  end

  test "should update Valuation" do
    visit valuation_url(@valuation)
    click_on "Edit this valuation", match: :first

    fill_in "Entity", with: @valuation.entity_id
    fill_in "Per share value", with: @valuation.per_share_value
    fill_in "Pre money valuation", with: @valuation.pre_money_valuation
    fill_in "Valuation date", with: @valuation.valuation_date
    click_on "Update Valuation"

    assert_text "Valuation was successfully updated"
    click_on "Back"
  end

  test "should destroy Valuation" do
    visit valuation_url(@valuation)
    click_on "Destroy this valuation", match: :first

    assert_text "Valuation was successfully destroyed"
  end
end
