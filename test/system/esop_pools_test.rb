require "application_system_test_case"

class EsopPoolsTest < ApplicationSystemTestCase
  setup do
    @esop_pool = esop_pools(:one)
  end

  test "visiting the index" do
    visit esop_pools_url
    assert_selector "h1", text: "Esop pools"
  end

  test "should create esop pool" do
    visit esop_pools_url
    click_on "New esop pool"

    fill_in "Entity", with: @esop_pool.entity_id
    fill_in "Excercise period months", with: @esop_pool.excercise_period_months
    fill_in "Excersice price", with: @esop_pool.excersice_price
    fill_in "Funding round", with: @esop_pool.funding_round_id
    fill_in "Name", with: @esop_pool.name
    fill_in "Number of options", with: @esop_pool.number_of_options
    fill_in "Start date", with: @esop_pool.start_date
    click_on "Create Esop pool"

    assert_text "Esop pool was successfully created"
    click_on "Back"
  end

  test "should update Esop pool" do
    visit esop_pool_url(@esop_pool)
    click_on "Edit this esop pool", match: :first

    fill_in "Entity", with: @esop_pool.entity_id
    fill_in "Excercise period months", with: @esop_pool.excercise_period_months
    fill_in "Excersice price", with: @esop_pool.excersice_price
    fill_in "Funding round", with: @esop_pool.funding_round_id
    fill_in "Name", with: @esop_pool.name
    fill_in "Number of options", with: @esop_pool.number_of_options
    fill_in "Start date", with: @esop_pool.start_date
    click_on "Update Esop pool"

    assert_text "Esop pool was successfully updated"
    click_on "Back"
  end

  test "should destroy Esop pool" do
    visit esop_pool_url(@esop_pool)
    click_on "Destroy this esop pool", match: :first

    assert_text "Esop pool was successfully destroyed"
  end
end
