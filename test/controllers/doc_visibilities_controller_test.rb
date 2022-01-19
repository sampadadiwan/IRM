require "test_helper"

class DocVisibilitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doc_visibility = doc_visibilities(:one)
  end

  test "should get index" do
    get doc_visibilities_url
    assert_response :success
  end

  test "should get new" do
    get new_doc_visibility_url
    assert_response :success
  end

  test "should create doc_visibility" do
    assert_difference("DocVisibility.count") do
      post doc_visibilities_url, params: { doc_visibility: { document_id: @doc_visibility.document_id, to: @doc_visibility.to, visiblity_type: @doc_visibility.visiblity_type } }
    end

    assert_redirected_to doc_visibility_url(DocVisibility.last)
  end

  test "should show doc_visibility" do
    get doc_visibility_url(@doc_visibility)
    assert_response :success
  end

  test "should get edit" do
    get edit_doc_visibility_url(@doc_visibility)
    assert_response :success
  end

  test "should update doc_visibility" do
    patch doc_visibility_url(@doc_visibility), params: { doc_visibility: { document_id: @doc_visibility.document_id, to: @doc_visibility.to, visiblity_type: @doc_visibility.visiblity_type } }
    assert_redirected_to doc_visibility_url(@doc_visibility)
  end

  test "should destroy doc_visibility" do
    assert_difference("DocVisibility.count", -1) do
      delete doc_visibility_url(@doc_visibility)
    end

    assert_redirected_to doc_visibilities_url
  end
end
