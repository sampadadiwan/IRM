Given("a Bulk Upload is performed for FundRatios with file {string}") do |file_name|
  visit(fund_path(@fund))
  click_on("Ratios")
  find("#fund_ratios_actions").click
  click_on("Upload")
  sleep(10)
  fill_in('import_upload_name', with: "Test Upload")
  attach_file('files[]', File.absolute_path("./public/sample_uploads/#{file_name}"), make_visible: true)
  sleep(10)
  click_on("Save")
  sleep(10)
  expect(page).to have_content("Import Upload:")
  ImportUploadJob.perform_now(ImportUpload.last.id)
  ImportUpload.last.failed_row_count.should == 0
end

Given("there is a CapitalCommitment with {string}") do |arg|
  capital_commitment = CapitalCommitment.last
  key_values(capital_commitment, arg)
  capital_commitment.save!
  investor = Investor.find_by(category: "Portfolio Company")
  investor.investor_name = "Portfolio Company 1"
  investor.save!
end


And("I should find Fund Ratios created with correct data for Fund") do
  visit(fund_path(@fund))
  click_on("Ratios")
  sleep(2)
  expect(page).to have_content("XIRR")
  expect(page).to have_content("27.95 %")
end

And("I should find Fund Ratios created with correct data for API") do
  fund_ratio = FundRatio.find_by(owner: AggregatePortfolioInvestment.last)
  expect(fund_ratio.name).to(eq("RVPI"))
  expect(fund_ratio.value).to(eq("0.14273e1".to_d))
  expect(fund_ratio.display_value).to(eq("1.43 x"))
  expect(fund_ratio.end_date).to(eq(Date.parse("2022-03-31")))
end

And("I should find Fund Ratios created with correct data for Capital Commitment") do
  visit(capital_commitment_path(CapitalCommitment.last))
  click_on("Ratios")
  expect(page).to have_content("XIRR")
  expect(page).to have_content("23.45 %")
  expect(page).to have_content("31/03/2022")
end

Then("the Fund ratios must be updated") do
  fund_ratio = FundRatio.find_by(name: "Fund Utilization")
  expect(fund_ratio.value).to(eq(-0.4521e0,))
  expect(fund_ratio.notes).to(eq("Updated"))
end
