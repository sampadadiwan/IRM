require "application_system_test_case"

class DealActivitiesTest < ApplicationSystemTestCase
  setup do
    @deal_activity = deal_activities(:one)
  end

  test "visiting the index" do
    visit deal_activities_url
    assert_selector "h1", text: "Deal activities"
  end

  test "should create deal activity" do
    visit deal_activities_url
    click_on "New deal activity"

    fill_in "By date", with: @deal_activity.by_date
    check "Completed" if @deal_activity.completed
    fill_in "Deal", with: @deal_activity.deal_id
    fill_in "Deal investor", with: @deal_activity.deal_investor_id
    fill_in "Entity", with: @deal_activity.entity_id
    fill_in "Status", with: @deal_activity.status
    click_on "Create Deal activity"

    assert_text "Deal activity was successfully created"
    click_on "Back"
  end

  test "should update Deal activity" do
    visit deal_activity_url(@deal_activity)
    click_on "Edit this deal activity", match: :first

    fill_in "By date", with: @deal_activity.by_date
    check "Completed" if @deal_activity.completed
    fill_in "Deal", with: @deal_activity.deal_id
    fill_in "Deal investor", with: @deal_activity.deal_investor_id
    fill_in "Entity", with: @deal_activity.entity_id
    fill_in "Status", with: @deal_activity.status
    click_on "Update Deal activity"

    assert_text "Deal activity was successfully updated"
    click_on "Back"
  end

  test "should destroy Deal activity" do
    visit deal_activity_url(@deal_activity)
    click_on "Destroy this deal activity", match: :first

    assert_text "Deal activity was successfully destroyed"
  end
end
