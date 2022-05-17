require "application_system_test_case"

class ExcercisesTest < ApplicationSystemTestCase
  setup do
    @excercise = excercises(:one)
  end

  test "visiting the index" do
    visit excercises_url
    assert_selector "h1", text: "Excercises"
  end

  test "should create excercise" do
    visit excercises_url
    click_on "New excercise"

    fill_in "Amount", with: @excercise.amount
    check "Approved" if @excercise.approved
    fill_in "Entity", with: @excercise.entity_id
    fill_in "Esop pool", with: @excercise.esop_pool_id
    fill_in "Holding", with: @excercise.holding_id
    fill_in "Price", with: @excercise.price
    fill_in "Quantity", with: @excercise.quantity
    fill_in "Tax", with: @excercise.tax
    fill_in "User", with: @excercise.user_id
    click_on "Create Excercise"

    assert_text "Excercise was successfully created"
    click_on "Back"
  end

  test "should update Excercise" do
    visit excercise_url(@excercise)
    click_on "Edit this excercise", match: :first

    fill_in "Amount", with: @excercise.amount
    check "Approved" if @excercise.approved
    fill_in "Entity", with: @excercise.entity_id
    fill_in "Esop pool", with: @excercise.esop_pool_id
    fill_in "Holding", with: @excercise.holding_id
    fill_in "Price", with: @excercise.price
    fill_in "Quantity", with: @excercise.quantity
    fill_in "Tax", with: @excercise.tax
    fill_in "User", with: @excercise.user_id
    click_on "Update Excercise"

    assert_text "Excercise was successfully updated"
    click_on "Back"
  end

  test "should destroy Excercise" do
    visit excercise_url(@excercise)
    click_on "Destroy this excercise", match: :first

    assert_text "Excercise was successfully destroyed"
  end
end
