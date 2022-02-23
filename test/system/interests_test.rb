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

    fill_in "Interest entity", with: @interest.interest_entity_id
    fill_in "Offer entity", with: @interest.offer_entity_id
    fill_in "Price", with: @interest.price
    fill_in "Quantity", with: @interest.quantity
    fill_in "Secondary sale", with: @interest.secondary_sale_id
    fill_in "User", with: @interest.user_id
    click_on "Create Interest"

    assert_text "Interest was successfully created"
    click_on "Back"
  end

  test "should update Interest" do
    visit interest_url(@interest)
    click_on "Edit this interest", match: :first

    fill_in "Interest entity", with: @interest.interest_entity_id
    fill_in "Offer entity", with: @interest.offer_entity_id
    fill_in "Price", with: @interest.price
    fill_in "Quantity", with: @interest.quantity
    fill_in "Secondary sale", with: @interest.secondary_sale_id
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
