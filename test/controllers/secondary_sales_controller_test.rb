require "test_helper"

class SecondarySalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @secondary_sale = secondary_sales(:one)
  end

  test "should get index" do
    get secondary_sales_url
    assert_response :success
  end

  test "should get new" do
    get new_secondary_sale_url
    assert_response :success
  end

  test "should create secondary_sale" do
    assert_difference("SecondarySale.count") do
      post secondary_sales_url, params: { secondary_sale: { active: @secondary_sale.active, end_date: @secondary_sale.end_date, entity_id: @secondary_sale.entity_id, max_price: @secondary_sale.max_price, min_price: @secondary_sale.min_price, name: @secondary_sale.name, percent_allowed: @secondary_sale.percent_allowed, start_date: @secondary_sale.start_date } }
    end

    assert_redirected_to secondary_sale_url(SecondarySale.last)
  end

  test "should show secondary_sale" do
    get secondary_sale_url(@secondary_sale)
    assert_response :success
  end

  test "should get edit" do
    get edit_secondary_sale_url(@secondary_sale)
    assert_response :success
  end

  test "should update secondary_sale" do
    patch secondary_sale_url(@secondary_sale), params: { secondary_sale: { active: @secondary_sale.active, end_date: @secondary_sale.end_date, entity_id: @secondary_sale.entity_id, max_price: @secondary_sale.max_price, min_price: @secondary_sale.min_price, name: @secondary_sale.name, percent_allowed: @secondary_sale.percent_allowed, start_date: @secondary_sale.start_date } }
    assert_redirected_to secondary_sale_url(@secondary_sale)
  end

  test "should destroy secondary_sale" do
    assert_difference("SecondarySale.count", -1) do
      delete secondary_sale_url(@secondary_sale)
    end

    assert_redirected_to secondary_sales_url
  end
end
