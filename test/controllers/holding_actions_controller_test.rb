require "test_helper"

class HoldingActionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @holding_action = holding_actions(:one)
  end

  test "should get index" do
    get holding_actions_url
    assert_response :success
  end

  test "should get new" do
    get new_holding_action_url
    assert_response :success
  end

  test "should create holding_action" do
    assert_difference("HoldingAction.count") do
      post holding_actions_url, params: { holding_action: { action: @holding_action.action, entity_id: @holding_action.entity_id, holding_id: @holding_action.holding_id, notes: @holding_action.notes, quantity: @holding_action.quantity, user_id: @holding_action.user_id } }
    end

    assert_redirected_to holding_action_url(HoldingAction.last)
  end

  test "should show holding_action" do
    get holding_action_url(@holding_action)
    assert_response :success
  end

  test "should get edit" do
    get edit_holding_action_url(@holding_action)
    assert_response :success
  end

  test "should update holding_action" do
    patch holding_action_url(@holding_action), params: { holding_action: { action: @holding_action.action, entity_id: @holding_action.entity_id, holding_id: @holding_action.holding_id, notes: @holding_action.notes, quantity: @holding_action.quantity, user_id: @holding_action.user_id } }
    assert_redirected_to holding_action_url(@holding_action)
  end

  test "should destroy holding_action" do
    assert_difference("HoldingAction.count", -1) do
      delete holding_action_url(@holding_action)
    end

    assert_redirected_to holding_actions_url
  end
end
