require "test_helper"

class DealDocsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @deal_doc = deal_docs(:one)
  end

  test "should get index" do
    get deal_docs_url
    assert_response :success
  end

  test "should get new" do
    get new_deal_doc_url
    assert_response :success
  end

  test "should create deal_doc" do
    assert_difference("DealDoc.count") do
      post deal_docs_url, params: { deal_doc: { deal_activity_id: @deal_doc.deal_activity_id, deal_id: @deal_doc.deal_id, deal_investor_id: @deal_doc.deal_investor_id, name: @deal_doc.name, user_id: @deal_doc.user_id } }
    end

    assert_redirected_to deal_doc_url(DealDoc.last)
  end

  test "should show deal_doc" do
    get deal_doc_url(@deal_doc)
    assert_response :success
  end

  test "should get edit" do
    get edit_deal_doc_url(@deal_doc)
    assert_response :success
  end

  test "should update deal_doc" do
    patch deal_doc_url(@deal_doc), params: { deal_doc: { deal_activity_id: @deal_doc.deal_activity_id, deal_id: @deal_doc.deal_id, deal_investor_id: @deal_doc.deal_investor_id, name: @deal_doc.name, user_id: @deal_doc.user_id } }
    assert_redirected_to deal_doc_url(@deal_doc)
  end

  test "should destroy deal_doc" do
    assert_difference("DealDoc.count", -1) do
      delete deal_doc_url(@deal_doc)
    end

    assert_redirected_to deal_docs_url
  end
end
