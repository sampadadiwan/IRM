require "test_helper"

class InvestmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @investment = investments(:one)
  end

  test "should get index" do
    get investments_url
    assert_response :success
  end

  test "should get new" do
    get new_investment_url
    assert_response :success
  end

  test "should create investment" do
    assert_difference("Investment.count") do
      post investments_url, params: { investment: { current_value: @investment.current_value, intial_value: @investment.intial_value, investee_company_id: @investment.investee_company_id, investment_instrument: @investment.investment_instrument, investment_type: @investment.investment_type, investor_company_id: @investment.investor_company_id, investor_type: @investment.investor_type, quantity: @investment.quantity } }
    end

    assert_redirected_to investment_url(Investment.last)
  end

  test "should show investment" do
    get investment_url(@investment)
    assert_response :success
  end

  test "should get edit" do
    get edit_investment_url(@investment)
    assert_response :success
  end

  test "should update investment" do
    patch investment_url(@investment), params: { investment: { current_value: @investment.current_value, intial_value: @investment.intial_value, investee_company_id: @investment.investee_company_id, investment_instrument: @investment.investment_instrument, investment_type: @investment.investment_type, investor_company_id: @investment.investor_company_id, investor_type: @investment.investor_type, quantity: @investment.quantity } }
    assert_redirected_to investment_url(@investment)
  end

  test "should destroy investment" do
    assert_difference("Investment.count", -1) do
      delete investment_url(@investment)
    end

    assert_redirected_to investments_url
  end
end
