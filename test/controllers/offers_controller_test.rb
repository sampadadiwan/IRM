require "test_helper"

class OffersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @offer = offers(:one)
  end

  test "should get index" do
    get offers_url
    assert_response :success
  end

  test "should get new" do
    get new_offer_url
    assert_response :success
  end

  test "should create offer" do
    assert_difference("Offer.count") do
      post offers_url, params: { offer: { entity_id: @offer.entity_id, notes: @offer.notes, percentage: @offer.percentage, quantity: @offer.quantity, secondary_sale_id: @offer.secondary_sale_id, user_id: @offer.user_id } }
    end

    assert_redirected_to offer_url(Offer.last)
  end

  test "should show offer" do
    get offer_url(@offer)
    assert_response :success
  end

  test "should get edit" do
    get edit_offer_url(@offer)
    assert_response :success
  end

  test "should update offer" do
    patch offer_url(@offer), params: { offer: { entity_id: @offer.entity_id, notes: @offer.notes, percentage: @offer.percentage, quantity: @offer.quantity, secondary_sale_id: @offer.secondary_sale_id, user_id: @offer.user_id } }
    assert_redirected_to offer_url(@offer)
  end

  test "should destroy offer" do
    assert_difference("Offer.count", -1) do
      delete offer_url(@offer)
    end

    assert_redirected_to offers_url
  end
end
