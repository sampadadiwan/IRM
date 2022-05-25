require "application_system_test_case"

class HoldingAuditTrailsTest < ApplicationSystemTestCase
  setup do
    @holding_audit_trail = holding_audit_trails(:one)
  end

  test "visiting the index" do
    visit holding_audit_trails_url
    assert_selector "h1", text: "Holding audit trails"
  end

  test "should create holding audit trail" do
    visit holding_audit_trails_url
    click_on "New holding audit trail"

    fill_in "Action", with: @holding_audit_trail.action
    fill_in "Action", with: @holding_audit_trail.action_id
    fill_in "Comments", with: @holding_audit_trail.comments
    fill_in "Entity", with: @holding_audit_trail.entity_id
    fill_in "Operation", with: @holding_audit_trail.operation
    fill_in "Owner", with: @holding_audit_trail.owner
    fill_in "Quantity", with: @holding_audit_trail.quantity
    fill_in "Ref", with: @holding_audit_trail.ref_id
    fill_in "Ref type", with: @holding_audit_trail.ref_type
    click_on "Create Holding audit trail"

    assert_text "Holding audit trail was successfully created"
    click_on "Back"
  end

  test "should update Holding audit trail" do
    visit holding_audit_trail_url(@holding_audit_trail)
    click_on "Edit this holding audit trail", match: :first

    fill_in "Action", with: @holding_audit_trail.action
    fill_in "Action", with: @holding_audit_trail.action_id
    fill_in "Comments", with: @holding_audit_trail.comments
    fill_in "Entity", with: @holding_audit_trail.entity_id
    fill_in "Operation", with: @holding_audit_trail.operation
    fill_in "Owner", with: @holding_audit_trail.owner
    fill_in "Quantity", with: @holding_audit_trail.quantity
    fill_in "Ref", with: @holding_audit_trail.ref_id
    fill_in "Ref type", with: @holding_audit_trail.ref_type
    click_on "Update Holding audit trail"

    assert_text "Holding audit trail was successfully updated"
    click_on "Back"
  end

  test "should destroy Holding audit trail" do
    visit holding_audit_trail_url(@holding_audit_trail)
    click_on "Destroy this holding audit trail", match: :first

    assert_text "Holding audit trail was successfully destroyed"
  end
end
