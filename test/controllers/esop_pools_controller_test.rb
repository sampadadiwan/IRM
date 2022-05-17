require "test_helper"

class EsopPoolsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @esop_pool = esop_pools(:one)
  end

  test "should get index" do
    get esop_pools_url
    assert_response :success
  end

  test "should get new" do
    get new_esop_pool_url
    assert_response :success
  end

  test "should create esop_pool" do
    assert_difference("EsopPool.count") do
      post esop_pools_url, params: { esop_pool: { entity_id: @esop_pool.entity_id, excercise_period_months: @esop_pool.excercise_period_months, excersice_price: @esop_pool.excersice_price, funding_round_id: @esop_pool.funding_round_id, name: @esop_pool.name, number_of_options: @esop_pool.number_of_options, start_date: @esop_pool.start_date } }
    end

    assert_redirected_to esop_pool_url(EsopPool.last)
  end

  test "should show esop_pool" do
    get esop_pool_url(@esop_pool)
    assert_response :success
  end

  test "should get edit" do
    get edit_esop_pool_url(@esop_pool)
    assert_response :success
  end

  test "should update esop_pool" do
    patch esop_pool_url(@esop_pool), params: { esop_pool: { entity_id: @esop_pool.entity_id, excercise_period_months: @esop_pool.excercise_period_months, excersice_price: @esop_pool.excersice_price, funding_round_id: @esop_pool.funding_round_id, name: @esop_pool.name, number_of_options: @esop_pool.number_of_options, start_date: @esop_pool.start_date } }
    assert_redirected_to esop_pool_url(@esop_pool)
  end

  test "should destroy esop_pool" do
    assert_difference("EsopPool.count", -1) do
      delete esop_pool_url(@esop_pool)
    end

    assert_redirected_to esop_pools_url
  end
end
