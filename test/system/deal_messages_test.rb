require "application_system_test_case"

class DealMessagesTest < ApplicationSystemTestCase
  setup do
    @deal_message = deal_messages(:one)
  end

  test "visiting the index" do
    visit deal_messages_url
    assert_selector "h1", text: "Deal messages"
  end

  test "should create deal message" do
    visit deal_messages_url
    click_on "New deal message"

    fill_in "Deal investor", with: @deal_message.deal_investor_id
    fill_in "User", with: @deal_message.user_id
    click_on "Create Deal message"

    assert_text "Deal message was successfully created"
    click_on "Back"
  end

  test "should update Deal message" do
    visit deal_message_url(@deal_message)
    click_on "Edit this deal message", match: :first

    fill_in "Deal investor", with: @deal_message.deal_investor_id
    fill_in "User", with: @deal_message.user_id
    click_on "Update Deal message"

    assert_text "Deal message was successfully updated"
    click_on "Back"
  end

  test "should destroy Deal message" do
    visit deal_message_url(@deal_message)
    click_on "Destroy this deal message", match: :first

    assert_text "Deal message was successfully destroyed"
  end
end
