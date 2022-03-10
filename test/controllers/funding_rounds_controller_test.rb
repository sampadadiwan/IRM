require "test_helper"

class FundingRoundsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @funding_round = funding_rounds(:one)
  end

  test "should get index" do
    get funding_rounds_url
    assert_response :success
  end

  test "should get new" do
    get new_funding_round_url
    assert_response :success
  end

  test "should create funding_round" do
    assert_difference("FundingRound.count") do
      post funding_rounds_url, params: { funding_round: { currency: @funding_round.currency, entity_id: @funding_round.entity_id, name: @funding_round.name, post_money_valuation_cents: @funding_round.post_money_valuation_cents, pre_money_valuation_cents: @funding_round.pre_money_valuation_cents, total_amount_cents: @funding_round.total_amount_cents } }
    end

    assert_redirected_to funding_round_url(FundingRound.last)
  end

  test "should show funding_round" do
    get funding_round_url(@funding_round)
    assert_response :success
  end

  test "should get edit" do
    get edit_funding_round_url(@funding_round)
    assert_response :success
  end

  test "should update funding_round" do
    patch funding_round_url(@funding_round), params: { funding_round: { currency: @funding_round.currency, entity_id: @funding_round.entity_id, name: @funding_round.name, post_money_valuation_cents: @funding_round.post_money_valuation_cents, pre_money_valuation_cents: @funding_round.pre_money_valuation_cents, total_amount_cents: @funding_round.total_amount_cents } }
    assert_redirected_to funding_round_url(@funding_round)
  end

  test "should destroy funding_round" do
    assert_difference("FundingRound.count", -1) do
      delete funding_round_url(@funding_round)
    end

    assert_redirected_to funding_rounds_url
  end
end
