require "test_helper"

class DealActivitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @deal_activity = deal_activities(:one)
  end

  test "should get index" do
    get deal_activities_url
    assert_response :success
  end

  test "should get new" do
    get new_deal_activity_url
    assert_response :success
  end

  test "should create deal_activity" do
    assert_difference("DealActivity.count") do
      post deal_activities_url, params: { deal_activity: { by_date: @deal_activity.by_date, completed: @deal_activity.completed, deal_id: @deal_activity.deal_id, deal_investor_id: @deal_activity.deal_investor_id, entity_id: @deal_activity.entity_id, status: @deal_activity.status } }
    end

    assert_redirected_to deal_activity_url(DealActivity.last)
  end

  test "should show deal_activity" do
    get deal_activity_url(@deal_activity)
    assert_response :success
  end

  test "should get edit" do
    get edit_deal_activity_url(@deal_activity)
    assert_response :success
  end

  test "should update deal_activity" do
    patch deal_activity_url(@deal_activity), params: { deal_activity: { by_date: @deal_activity.by_date, completed: @deal_activity.completed, deal_id: @deal_activity.deal_id, deal_investor_id: @deal_activity.deal_investor_id, entity_id: @deal_activity.entity_id, status: @deal_activity.status } }
    assert_redirected_to deal_activity_url(@deal_activity)
  end

  test "should destroy deal_activity" do
    assert_difference("DealActivity.count", -1) do
      delete deal_activity_url(@deal_activity)
    end

    assert_redirected_to deal_activities_url
  end
end
