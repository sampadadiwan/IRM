require "test_helper"

class InvestorAccessesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @investor_access = investor_accesses(:one)
  end

  test "should get index" do
    get investor_accesses_url
    assert_response :success
  end

  test "should get new" do
    get new_investor_access_url
    assert_response :success
  end

  test "should create investor_access" do
    assert_difference("InvestorAccess.count") do
      post investor_accesses_url, params: { investor_access: { access_type: @investor_access.access_type, email: @investor_access.email, granted_by: @investor_access.granted_by, investor_id: @investor_access.investor_id } }
    end

    assert_redirected_to investor_access_url(InvestorAccess.last)
  end

  test "should show investor_access" do
    get investor_access_url(@investor_access)
    assert_response :success
  end

  test "should get edit" do
    get edit_investor_access_url(@investor_access)
    assert_response :success
  end

  test "should update investor_access" do
    patch investor_access_url(@investor_access), params: { investor_access: { access_type: @investor_access.access_type, email: @investor_access.email, granted_by: @investor_access.granted_by, investor_id: @investor_access.investor_id } }
    assert_redirected_to investor_access_url(@investor_access)
  end

  test "should destroy investor_access" do
    assert_difference("InvestorAccess.count", -1) do
      delete investor_access_url(@investor_access)
    end

    assert_redirected_to investor_accesses_url
  end
end
