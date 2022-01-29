require "test_helper"

class DealMessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @deal_message = deal_messages(:one)
  end

  test "should get index" do
    get deal_messages_url
    assert_response :success
  end

  test "should get new" do
    get new_deal_message_url
    assert_response :success
  end

  test "should create deal_message" do
    assert_difference("DealMessage.count") do
      post deal_messages_url, params: { deal_message: { deal_investor_id: @deal_message.deal_investor_id, user_id: @deal_message.user_id } }
    end

    assert_redirected_to deal_message_url(DealMessage.last)
  end

  test "should show deal_message" do
    get deal_message_url(@deal_message)
    assert_response :success
  end

  test "should get edit" do
    get edit_deal_message_url(@deal_message)
    assert_response :success
  end

  test "should update deal_message" do
    patch deal_message_url(@deal_message), params: { deal_message: { deal_investor_id: @deal_message.deal_investor_id, user_id: @deal_message.user_id } }
    assert_redirected_to deal_message_url(@deal_message)
  end

  test "should destroy deal_message" do
    assert_difference("DealMessage.count", -1) do
      delete deal_message_url(@deal_message)
    end

    assert_redirected_to deal_messages_url
  end
end
