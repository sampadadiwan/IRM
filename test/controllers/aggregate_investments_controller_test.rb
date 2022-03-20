require "test_helper"

class AggregateInvestmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @aggregate_investment = aggregate_investments(:one)
  end

  test "should get index" do
    get aggregate_investments_url
    assert_response :success
  end

  test "should get new" do
    get new_aggregate_investment_url
    assert_response :success
  end

  test "should create aggregate_investment" do
    assert_difference("AggregateInvestment.count") do
      post aggregate_investments_url, params: { aggregate_investment: { entity_id: @aggregate_investment.entity_id, equity: @aggregate_investment.equity, full_diluted_percentage: @aggregate_investment.full_diluted_percentage, funding_round_id: @aggregate_investment.funding_round_id, investor_id: @aggregate_investment.investor_id, options: @aggregate_investment.options, percentage: @aggregate_investment.percentage, preferred: @aggregate_investment.preferred, shareholder: @aggregate_investment.shareholder } }
    end

    assert_redirected_to aggregate_investment_url(AggregateInvestment.last)
  end

  test "should show aggregate_investment" do
    get aggregate_investment_url(@aggregate_investment)
    assert_response :success
  end

  test "should get edit" do
    get edit_aggregate_investment_url(@aggregate_investment)
    assert_response :success
  end

  test "should update aggregate_investment" do
    patch aggregate_investment_url(@aggregate_investment), params: { aggregate_investment: { entity_id: @aggregate_investment.entity_id, equity: @aggregate_investment.equity, full_diluted_percentage: @aggregate_investment.full_diluted_percentage, funding_round_id: @aggregate_investment.funding_round_id, investor_id: @aggregate_investment.investor_id, options: @aggregate_investment.options, percentage: @aggregate_investment.percentage, preferred: @aggregate_investment.preferred, shareholder: @aggregate_investment.shareholder } }
    assert_redirected_to aggregate_investment_url(@aggregate_investment)
  end

  test "should destroy aggregate_investment" do
    assert_difference("AggregateInvestment.count", -1) do
      delete aggregate_investment_url(@aggregate_investment)
    end

    assert_redirected_to aggregate_investments_url
  end
end
