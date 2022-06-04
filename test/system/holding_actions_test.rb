require "application_system_test_case"

class HoldingActionsTest < ApplicationSystemTestCase
  setup do
    @holding_action = holding_actions(:one)
  end

  test "visiting the index" do
    visit holding_actions_url
    assert_selector "h1", text: "Holding actions"
  end

  test "should create holding action" do
    visit holding_actions_url
    click_on "New holding action"

    fill_in "Action", with: @holding_action.action
    fill_in "Entity", with: @holding_action.entity_id
    fill_in "Holding", with: @holding_action.holding_id
    fill_in "Notes", with: @holding_action.notes
    fill_in "Quantity", with: @holding_action.quantity
    fill_in "User", with: @holding_action.user_id
    click_on "Create Holding action"

    assert_text "Holding action was successfully created"
    click_on "Back"
  end

  test "should update Holding action" do
    visit holding_action_url(@holding_action)
    click_on "Edit this holding action", match: :first

    fill_in "Action", with: @holding_action.action
    fill_in "Entity", with: @holding_action.entity_id
    fill_in "Holding", with: @holding_action.holding_id
    fill_in "Notes", with: @holding_action.notes
    fill_in "Quantity", with: @holding_action.quantity
    fill_in "User", with: @holding_action.user_id
    click_on "Update Holding action"

    assert_text "Holding action was successfully updated"
    click_on "Back"
  end

  test "should destroy Holding action" do
    visit holding_action_url(@holding_action)
    click_on "Destroy this holding action", match: :first

    assert_text "Holding action was successfully destroyed"
  end
end
