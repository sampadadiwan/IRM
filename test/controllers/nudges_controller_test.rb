require "test_helper"

class NudgesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @nudge = nudges(:one)
  end

  test "should get index" do
    get nudges_url
    assert_response :success
  end

  test "should get new" do
    get new_nudge_url
    assert_response :success
  end

  test "should create nudge" do
    assert_difference("Nudge.count") do
      post nudges_url, params: { nudge: { entity_id: @nudge.entity_id, item_id: @nudge.item_id, item_type: @nudge.item_type, msg_body: @nudge.msg_body, subject: @nudge.subject, to: @nudge.to, user_id: @nudge.user_id } }
    end

    assert_redirected_to nudge_url(Nudge.last)
  end

  test "should show nudge" do
    get nudge_url(@nudge)
    assert_response :success
  end

  test "should get edit" do
    get edit_nudge_url(@nudge)
    assert_response :success
  end

  test "should update nudge" do
    patch nudge_url(@nudge), params: { nudge: { entity_id: @nudge.entity_id, item_id: @nudge.item_id, item_type: @nudge.item_type, msg_body: @nudge.msg_body, subject: @nudge.subject, to: @nudge.to, user_id: @nudge.user_id } }
    assert_redirected_to nudge_url(@nudge)
  end

  test "should destroy nudge" do
    assert_difference("Nudge.count", -1) do
      delete nudge_url(@nudge)
    end

    assert_redirected_to nudges_url
  end
end
