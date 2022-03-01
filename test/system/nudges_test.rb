require "application_system_test_case"

class NudgesTest < ApplicationSystemTestCase
  setup do
    @nudge = nudges(:one)
  end

  test "visiting the index" do
    visit nudges_url
    assert_selector "h1", text: "Nudges"
  end

  test "should create nudge" do
    visit nudges_url
    click_on "New nudge"

    fill_in "Entity", with: @nudge.entity_id
    fill_in "Item", with: @nudge.item_id
    fill_in "Item type", with: @nudge.item_type
    fill_in "Msg body", with: @nudge.msg_body
    fill_in "Subject", with: @nudge.subject
    fill_in "To", with: @nudge.to
    fill_in "User", with: @nudge.user_id
    click_on "Create Nudge"

    assert_text "Nudge was successfully created"
    click_on "Back"
  end

  test "should update Nudge" do
    visit nudge_url(@nudge)
    click_on "Edit this nudge", match: :first

    fill_in "Entity", with: @nudge.entity_id
    fill_in "Item", with: @nudge.item_id
    fill_in "Item type", with: @nudge.item_type
    fill_in "Msg body", with: @nudge.msg_body
    fill_in "Subject", with: @nudge.subject
    fill_in "To", with: @nudge.to
    fill_in "User", with: @nudge.user_id
    click_on "Update Nudge"

    assert_text "Nudge was successfully updated"
    click_on "Back"
  end

  test "should destroy Nudge" do
    visit nudge_url(@nudge)
    click_on "Destroy this nudge", match: :first

    assert_text "Nudge was successfully destroyed"
  end
end
