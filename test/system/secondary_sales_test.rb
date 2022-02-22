require "application_system_test_case"

class SecondarySalesTest < ApplicationSystemTestCase
  setup do
    @secondary_sale = secondary_sales(:one)
  end

  test "visiting the index" do
    visit secondary_sales_url
    assert_selector "h1", text: "Secondary sales"
  end

  test "should create secondary sale" do
    visit secondary_sales_url
    click_on "New secondary sale"

    check "Active" if @secondary_sale.active
    fill_in "End date", with: @secondary_sale.end_date
    fill_in "Entity", with: @secondary_sale.entity_id
    fill_in "Max price", with: @secondary_sale.max_price
    fill_in "Min price", with: @secondary_sale.min_price
    fill_in "Name", with: @secondary_sale.name
    fill_in "Percent allowed", with: @secondary_sale.percent_allowed
    fill_in "Start date", with: @secondary_sale.start_date
    click_on "Create Secondary sale"

    assert_text "Secondary sale was successfully created"
    click_on "Back"
  end

  test "should update Secondary sale" do
    visit secondary_sale_url(@secondary_sale)
    click_on "Edit this secondary sale", match: :first

    check "Active" if @secondary_sale.active
    fill_in "End date", with: @secondary_sale.end_date
    fill_in "Entity", with: @secondary_sale.entity_id
    fill_in "Max price", with: @secondary_sale.max_price
    fill_in "Min price", with: @secondary_sale.min_price
    fill_in "Name", with: @secondary_sale.name
    fill_in "Percent allowed", with: @secondary_sale.percent_allowed
    fill_in "Start date", with: @secondary_sale.start_date
    click_on "Update Secondary sale"

    assert_text "Secondary sale was successfully updated"
    click_on "Back"
  end

  test "should destroy Secondary sale" do
    visit secondary_sale_url(@secondary_sale)
    click_on "Destroy this secondary sale", match: :first

    assert_text "Secondary sale was successfully destroyed"
  end
end
