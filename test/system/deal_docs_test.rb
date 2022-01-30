require "application_system_test_case"

class DealDocsTest < ApplicationSystemTestCase
  setup do
    @deal_doc = deal_docs(:one)
  end

  test "visiting the index" do
    visit deal_docs_url
    assert_selector "h1", text: "Deal docs"
  end

  test "should create deal doc" do
    visit deal_docs_url
    click_on "New deal doc"

    fill_in "Deal activity", with: @deal_doc.deal_activity_id
    fill_in "Deal", with: @deal_doc.deal_id
    fill_in "Deal investor", with: @deal_doc.deal_investor_id
    fill_in "Name", with: @deal_doc.name
    fill_in "User", with: @deal_doc.user_id
    click_on "Create Deal doc"

    assert_text "Deal doc was successfully created"
    click_on "Back"
  end

  test "should update Deal doc" do
    visit deal_doc_url(@deal_doc)
    click_on "Edit this deal doc", match: :first

    fill_in "Deal activity", with: @deal_doc.deal_activity_id
    fill_in "Deal", with: @deal_doc.deal_id
    fill_in "Deal investor", with: @deal_doc.deal_investor_id
    fill_in "Name", with: @deal_doc.name
    fill_in "User", with: @deal_doc.user_id
    click_on "Update Deal doc"

    assert_text "Deal doc was successfully updated"
    click_on "Back"
  end

  test "should destroy Deal doc" do
    visit deal_doc_url(@deal_doc)
    click_on "Destroy this deal doc", match: :first

    assert_text "Deal doc was successfully destroyed"
  end
end
