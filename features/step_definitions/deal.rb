include InvestmentsHelper

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
  expect(page).to have_content(money_to_currency(@deal.amount))
  expect(page).to have_content(@deal.status)
end

Then('I should see the deal in all deals page') do
  visit("/deals")
  expect(page).to have_content(@deal.name)
  expect(page).to have_content(money_to_currency(@deal.amount))
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


Given('given there is a deal {string} for the entity') do |arg1|
  @deal = FactoryBot.build(:deal, entity_id: @entity.id)
  key_values(@deal, arg1)
  @deal.save
end

Given('I should have access to the deal') do
  Pundit.policy(@user, @deal).show?.should == true
end


Given('I should not have access to the deal') do
  Pundit.policy(@user, @deal).show?.should == false
end

Given('another user {string} have access to the deal') do |arg|
  Pundit.policy(@another_user, @deal).show?.to_s.should == arg
end


Given('another entity is an investor {string} in entity') do |arg|
  @investor = Investor.new(investor_entity: @another_entity, investee_entity: @entity)  
  key_values(@investor, arg)
  @investor.save
  puts "\n####Investor####\n"
  puts @investor.to_json
end


Given('another user has investor access {string} in the investor') do |arg|
  @investor_access = InvestorAccess.new(entity: @entity, investor: @investor, 
                            email: @another_user.email, granter: @user )
  key_values(@investor_access, arg)

  @investor_access.save!
  puts "\n####Investor Access####\n"
  puts @investor_access.to_json
end


Given('investor has access right {string} in the deal') do |arg1|
  @access_right = AccessRight.new(owner: @deal, entity: @entity)
  key_values(@access_right, arg1)
  @access_right.save!
  puts "\n####Access Right####\n"
  puts @access_right.to_json
end

