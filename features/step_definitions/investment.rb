include InvestmentsHelper

Given('I am at the investments page') do
  visit("/investments")
end

Given('I create an investment {string}') do |arg1|
  @investment = FactoryBot.build(:investment, investee_entity: @entity)
  @investment.currency = @entity.currency
  key_values(@investment, arg1)
  # puts @investment.investor.to_json
  # puts "investor_name = " + @investment.investor.investor_name

  click_on("New Investment")

  select(@investment.investor.investor_name, from: "investment_investor_id")
  select(@investment.category, from: "investment_category")
  select(@investment.investment_type, from: "investment_investment_type")
  select(@investment.investment_instrument, from: "investment_investment_instrument")

  fill_in('investment_quantity', with: @investment.quantity)
  fill_in('investment_price', with: @investment.price)
  click_on("Save")
end

Then('an investment should be created') do
  @created = Investment.last
  puts "\n####Investment Created####\n"
  puts @created.to_json

  @created.investor_id.should == @investment.investor_id
  @created.category.should == @investment.category
  @created.investment_type.should == @investment.investment_type
  @created.investment_instrument.should == @investment.investment_instrument
  @created.quantity.should == @investment.quantity
  @created.price_cents.should == @investment.price_cents
  @created.currency.should == @investment.investee_entity.currency
  @created.amount.should == @investment.price * @investment.quantity 
  @investment = @created
end

Then('I should see the investment details on the details page') do
  expect(page).to have_content(@investment.investor.investor_name)
  expect(page).to have_content(@investment.category)
  expect(page).to have_content(@investment.investment_instrument)
  expect(page).to have_content(@investment.investment_type)
  expect(page).to have_content(@investment.quantity)
  expect(page).to have_content(money_to_currency(@investment.price))
  expect(page).to have_content(money_to_currency(@investment.amount))
end

Then('I should see the investment in all investments page') do
  visit("/investments")
  expect(page).to have_content(@investment.investor.investor_name)
  expect(page).to have_content(@investment.category)
  expect(page).to have_content(@investment.investment_instrument)
  expect(page).to have_content(@investment.investment_type)
  expect(page).to have_content(@investment.quantity)
  expect(page).to have_content(money_to_currency(@investment.price))
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
  
  @access_right.save
  puts "\n####Access Right####\n"
  puts @access_right.to_json
end


Then('a holding should be created for the investor') do
  sleep(1)
  @holding = Holding.last
  puts "\n####Holding####\n"
  puts @holding.to_json

  @holding.quantity.should == @investment.quantity
  @holding.investment_instrument.should == @investment.investment_instrument
  @holding.entity_id.should == @investment.investee_entity_id  
  @holding.investor_id.should == @investment.investor_id
  @holding.user_id.should == nil
  @holding.holding_type.should == "Investor"
end



Given('there are {string} employee investors') do |arg|
  @holdings_investor = @entity.investors.where(is_holdings_entity: true).first
  @investor_entity = @holdings_investor.investor_entity
  (0..arg.to_i-1).each do
    user = FactoryBot.create(:user, entity: @investor_entity)
    ia = InvestorAccess.create!(investor:@holdings_investor, user: user, email: user.email, 
        approved: true, entity_id: @holdings_investor.investee_entity_id)

    puts "\n####InvestorAccess####\n"
    puts ia.to_json
  end
end

Given('Given I create a holding for each employee with quantity {string}') do |arg|
  @holding_quantity = arg.to_i
  @entity.investor_accesses.each do |emp|
    visit(investor_url(@holdings_investor))
    click_on("Employee Investors")
    find("#investor_access_#{emp.id}").click_link("Add Holding")
    fill_in('holding_quantity', with: @holding_quantity)
    select("Equity", from: "holding_investment_instrument")

    click_on("Save")
    sleep(1)
  end
end

Then('There should be a corresponding holdings created for each employee') do

  puts Holding.all.to_json
    
  @investor_entity.employees.each do |emp|
    emp.holdings.count.should == 1
    holding = emp.holdings.first
    holding.quantity.should == @holding_quantity
    holding.holding_type.should == "Employee"
    holding.entity_id.should == @entity.id
    holding.investment_instrument.should == "Equity"
  end
end

Then('There should be a corresponding investment created') do
  @holding_investment = Investment.first
  @holding_investment.investee_entity_id.should == @entity.id
  @holding_investment.investor_entity_id.should == @investor_entity.id
  @holding_investment.investment_instrument.should == "Equity"
  @holding_investment.quantity.should == Holding.all.sum(:quantity)
  @holding_investment.investment_type.should == "Employee Holdings"
end
