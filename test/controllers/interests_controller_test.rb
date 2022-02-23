require "test_helper"

class InterestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @interest = interests(:one)
  end

  test "should get index" do
    get interests_url
    assert_response :success
  end

  test "should get new" do
    get new_interest_url
    assert_response :success
  end

  test "should create interest" do
    assert_difference("Interest.count") do
      post interests_url, params: { interest: { interest_entity_id: @interest.interest_entity_id, offer_entity_id: @interest.offer_entity_id, price: @interest.price, quantity: @interest.quantity, secondary_sale_id: @interest.secondary_sale_id, user_id: @interest.user_id } }
    end

    assert_redirected_to interest_url(Interest.last)
  end

  test "should show interest" do
    get interest_url(@interest)
    assert_response :success
  end

  test "should get edit" do
    get edit_interest_url(@interest)
    assert_response :success
  end

  test "should update interest" do
    patch interest_url(@interest), params: { interest: { interest_entity_id: @interest.interest_entity_id, offer_entity_id: @interest.offer_entity_id, price: @interest.price, quantity: @interest.quantity, secondary_sale_id: @interest.secondary_sale_id, user_id: @interest.user_id } }
    assert_redirected_to interest_url(@interest)
  end

  test "should destroy interest" do
    assert_difference("Interest.count", -1) do
      delete interest_url(@interest)
    end

    assert_redirected_to interests_url
  end
end
