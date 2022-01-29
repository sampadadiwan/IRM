require "test_helper"

class DealInvestorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @deal_investor = deal_investors(:one)
  end

  test "should get index" do
    get deal_investors_url
    assert_response :success
  end

  test "should get new" do
    get new_deal_investor_url
    assert_response :success
  end

  test "should create deal_investor" do
    assert_difference("DealInvestor.count") do
      post deal_investors_url, params: { deal_investor: { deal_id: @deal_investor.deal_id, entity_id: @deal_investor.entity_id, investor_id: @deal_investor.investor_id, primary_amount: @deal_investor.primary_amount, secondary_investment: @deal_investor.secondary_investment, status: @deal_investor.status } }
    end

    assert_redirected_to deal_investor_url(DealInvestor.last)
  end

  test "should show deal_investor" do
    get deal_investor_url(@deal_investor)
    assert_response :success
  end

  test "should get edit" do
    get edit_deal_investor_url(@deal_investor)
    assert_response :success
  end

  test "should update deal_investor" do
    patch deal_investor_url(@deal_investor), params: { deal_investor: { deal_id: @deal_investor.deal_id, entity_id: @deal_investor.entity_id, investor_id: @deal_investor.investor_id, primary_amount: @deal_investor.primary_amount, secondary_investment: @deal_investor.secondary_investment, status: @deal_investor.status } }
    assert_redirected_to deal_investor_url(@deal_investor)
  end

  test "should destroy deal_investor" do
    assert_difference("DealInvestor.count", -1) do
      delete deal_investor_url(@deal_investor)
    end

    assert_redirected_to deal_investors_url
  end
end
