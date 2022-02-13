Given('I am at the investments page') do
  visit("/investments")
end

Given('I create an investment {string}') do |arg1|
  @investment = FactoryBot.build(:investment)
  key_values(@investment, arg1)

  click_on("New Investment")

  select(@investment.investor.investor_name, from: "investment_investor_id")
  select(@investment.category, from: "investment_category")
  select(@investment.investment_type, from: "investment_investment_type")
  select(@investment.investment_instrument, from: "investment_investment_instrument")

  fill_in('investment_quantity', with: @investment.quantity)
  fill_in('investment_initial_value', with: @investment.initial_value)
  click_on("Save")
end

Then('an investment should be created') do
  @created = Investment.last
  @created.investor_id.should == @investment.investor_id
  @created.category.should == @investment.category
  @created.investment_type.should == @investment.investment_type
  @created.investment_instrument.should == @investment.investment_instrument
  @created.quantity.should == @investment.quantity
  @created.initial_value.should == @investment.initial_value
end

Then('I should see the investment details on the details page') do
  expect(page).to have_content(@investment.investor.investor_name)
  expect(page).to have_content(@investment.category)
  expect(page).to have_content(@investment.investment_instrument)
  expect(page).to have_content(@investment.investment_type)
  expect(page).to have_content(@investment.quantity)
  expect(page).to have_content(@investment.initial_value)
end

Then('I should see the investment in all investments page') do
  visit("/investments")
  expect(page).to have_content(@investment.investor.investor_name)
  expect(page).to have_content(@investment.category)
  expect(page).to have_content(@investment.investment_instrument)
  expect(page).to have_content(@investment.investment_type)
  expect(page).to have_content(@investment.quantity)
  expect(page).to have_content(@investment.initial_value)
end


Given('given there is a investment {string} for the entity') do |arg1|
  @investment = FactoryBot.build(:investment, investor: @investor, investee_entity: @entity)
  key_values(@investment, arg1)
  @investment.save!
  puts "\n####Investment####\n"
  puts @investment.to_json
end

Given('I should have access to the investment') do
  Pundit.policy(@user, @investment).show?.should == true
end


Given('another user has {string} access to the investment') do |arg|
  Pundit.policy(@another_user, @investment).show?.to_s.should == arg
end

Given('investor has access right {string} in the investment') do |arg1|
  @access_right = AccessRight.new(owner: @entity, entity: @entity)
  key_values(@access_right, arg1)
  puts @access_right.to_json
  
  @access_right.save
  puts "\n####Access Right####\n"
  puts @access_right.to_json
end


