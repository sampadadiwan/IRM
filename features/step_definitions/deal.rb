Given('I am at the deals page') do
  visit("/deals")
end

When('I create a new deal {string}') do |arg1|
  @deal = FactoryBot.build(:deal)
  key_values(@deal, arg1)

  click_on("New Deal")
  fill_in('deal_name', with: @deal.name)
  fill_in('deal_amount', with: @deal.amount)
  select(@deal.status, from: "deal_status")
  click_on("Save")
end

Then('an deal should be created') do
  @created = Deal.last
  @created.name.should == @deal.name
  @created.amount.should == @deal.amount
  @created.status.should == @deal.status
end

Then('I should see the deal details on the details page') do
  expect(page).to have_content(@deal.name)
  expect(page).to have_content(@deal.amount)
  expect(page).to have_content(@deal.status)
end

Then('I should see the deal in all deals page') do
  visit("/deals")
  expect(page).to have_content(@deal.name)
  expect(page).to have_content(@deal.amount)
  expect(page).to have_content(@deal.status)
end

Given('I visit the deal details page') do
  visit(deal_url(@deal))
end


Given('there exists a deal {string} for my startup') do |arg1|
  @deal = FactoryBot.build(:deal)
  key_values(@deal, arg1)
  @deal.save
  puts "\n####Deal####\n"
  puts @deal.to_json
end

Given('when I start the deal') do
  click_on("Start Deal")
end

Then('the deal should be started') do
  @deal.reload
  @deal.start_date.should_not == nil
  sleep(1)
  @deal.deal_activities.should_not == nil
end
