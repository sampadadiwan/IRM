require "test_helper"

class HoldingAuditTrailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @holding_audit_trail = holding_audit_trails(:one)
  end

  test "should get index" do
    get holding_audit_trails_url
    assert_response :success
  end

  test "should get new" do
    get new_holding_audit_trail_url
    assert_response :success
  end

  test "should create holding_audit_trail" do
    assert_difference("HoldingAuditTrail.count") do
      post holding_audit_trails_url, params: { holding_audit_trail: { action: @holding_audit_trail.action, action_id: @holding_audit_trail.action_id, comments: @holding_audit_trail.comments, entity_id: @holding_audit_trail.entity_id, operation: @holding_audit_trail.operation, owner: @holding_audit_trail.owner, quantity: @holding_audit_trail.quantity, ref_id: @holding_audit_trail.ref_id, ref_type: @holding_audit_trail.ref_type } }
    end

    assert_redirected_to holding_audit_trail_url(HoldingAuditTrail.last)
  end

  test "should show holding_audit_trail" do
    get holding_audit_trail_url(@holding_audit_trail)
    assert_response :success
  end

  test "should get edit" do
    get edit_holding_audit_trail_url(@holding_audit_trail)
    assert_response :success
  end

  test "should update holding_audit_trail" do
    patch holding_audit_trail_url(@holding_audit_trail), params: { holding_audit_trail: { action: @holding_audit_trail.action, action_id: @holding_audit_trail.action_id, comments: @holding_audit_trail.comments, entity_id: @holding_audit_trail.entity_id, operation: @holding_audit_trail.operation, owner: @holding_audit_trail.owner, quantity: @holding_audit_trail.quantity, ref_id: @holding_audit_trail.ref_id, ref_type: @holding_audit_trail.ref_type } }
    assert_redirected_to holding_audit_trail_url(@holding_audit_trail)
  end

  test "should destroy holding_audit_trail" do
    assert_difference("HoldingAuditTrail.count", -1) do
      delete holding_audit_trail_url(@holding_audit_trail)
    end

    assert_redirected_to holding_audit_trails_url
  end
end
