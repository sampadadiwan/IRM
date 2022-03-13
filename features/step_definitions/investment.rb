include InvestmentsHelper

Given('I am at the investments page') do
  visit("/investments")
end

Given('I create an investment {string}') do |arg1|
  @funding_round = FactoryBot.create(:funding_round, entity: @entity)
  @investment = FactoryBot.build(:investment, investee_entity: @entity, 
                      investment_type: @funding_round.name, funding_round: @funding_round)
  @investment.currency = @entity.currency
  key_values(@investment, arg1)
  # puts @investment.investor.to_json
  # puts "investor_name = " + @investment.investor.investor_name

  click_on("New Investment")

  select(@investment.investor.investor_name, from: "investment_investor_id")
  select(@investment.category, from: "investment_category")
  select(@investment.funding_round.name, from: "investment_funding_round_id")
  select(@investment.investment_instrument, from: "investment_investment_instrument")

  fill_in('investment_quantity', with: @investment.quantity)
  fill_in('investment_price', with: @investment.price)
  click_on("Save")
end


Then('when I edit the investment {string}') do |arg1|
  visit(investment_path(@investment))
  click_on("Edit")
  @edit_investment = @investment
  key_values(@edit_investment, arg1)

  select(@edit_investment.category, from: "investment_category")
  select(@edit_investment.investment_type, from: "investment_funding_round_id")
  select(@edit_investment.investment_instrument, from: "investment_investment_instrument")
  
  fill_in('investment_quantity', with: @edit_investment.quantity)
  fill_in('investment_price', with: @edit_investment.price)
  click_on("Save")
  sleep(1)
  @investment = Investment.last
  
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
  visit(investment_path(@investment))
  steps %(
    Then I should see the investment details    
  )
  expect(page).to have_content(money_to_currency(@investment.amount))
end

Then('I should see the investment in all investments page') do
  visit("/investments")
  steps %(
    Then I should see the investment details    
  )
end

Then('I should see the investment details') do
  expect(page).to have_content(@investment.investor.investor_name)
  expect(page).to have_content(@investment.category)
  expect(page).to have_content(@investment.investment_instrument)
  expect(page).to have_content(@investment.investment_type)
  expect(page).to have_content(@investment.quantity)
  expect(page).to have_content(money_to_currency(@investment.price))
end

Given('given there is a investment {string} for the entity') do |arg1|
  @investment = FactoryBot.build(:investment, investor: @investor, investee_entity: @entity)
  @investment.currency = @entity.currency
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
    select("Employee", from: "holding_holding_type")

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


############################################################################
############################################################################
#######################  VC related test steps #############################  
############################################################################
############################################################################


Given('there are {string} exisiting investments {string} from my firm in startups') do |count, args|
  (1..count.to_i).each do |i|
    @startup_entity = FactoryBot.create(:entity, entity_type: "Startup", name: "Startup #{i}")
    @investor = FactoryBot.create(:investor, investor_entity: @entity, investee_entity: @startup_entity)
    (1..count.to_i).each do 
      @investment = FactoryBot.create(:investment, investee_entity: @startup_entity, investor: @investor)
    end
  end
end


Given('there are {string} exisiting investments {string} from another firm in startups') do |count, args|
  @another_entity = FactoryBot.create(:entity, entity_type: "VC", name: "Another VC Firm")
  Entity.startups.each do |startup|
    @investor = FactoryBot.create(:investor, investor_entity: @another_entity, investee_entity: startup)
    (1..count.to_i).each do 
      @investment = FactoryBot.create(:investment, investee_entity: startup, investor: @investor)
    end
  end
end


Given('I am at the investor_entities page') do
  visit(investor_entities_entities_path)
end

Then('I should see the entities I have invested in') do
  @entity.investments.each do |inv|
    expect(page).to have_content(inv.investee_entity.name)
  end
end

Then('I should not see the entities I have invested in') do
  @entity.investments.each do |inv|
    expect(page).to have_no_content(inv.investee_entity.name)
  end
end

Given('I have been granted access {string} to the investments') do |arg|
  Investment.joins(:investor).where("investors.investor_entity_id=?", @entity.id).each do |inv|
    InvestorAccess.create!(investor:inv.investor, user: @user, email: @user.email, approved: true, 
        entity_id: inv.investee_entity_id)

    AccessRight.create(owner: inv.investee_entity, access_type: "Investment", metadata: arg,
        entity: inv.investee_entity, access_to_investor_id: inv.investor_id)
  end

end


Then('I should be able to see the investments for each entity') do
  Entity.startups.each do |entity|
    entity.investments.each do |inv|
      visit(investor_entities_entities_path)
      find("#investments_entity_#{entity.id}").click
      @investment = inv
      steps %(
        Then I should see the investment details   
        Then I should see the investment details on the details page    
      )
    end  
    visit(investor_entities_entities_path)    
  end
end


Then('I should be able to see only my investments for each entity') do
  Entity.startups.each do |entity|
    entity.investments.each do |inv|
      visit(investor_entities_entities_path)
      find("#investments_entity_#{entity.id}").click
      @investment = inv
      if @investment.investor_entity_id == @entity.id
      steps %(
        Then I should see the investment details   
        Then I should see the investment details on the details page    
      )
      else
        expect(page).to have_no_content(@investment.investor.investor_name)
      end
    end  
    visit(investor_entities_entities_path)    
  end
end



Given('Given I upload a holdings file') do
  Sidekiq.redis(&:flushdb)

  @existing_user_count = User.count
  visit("/holdings")
  click_on("Upload Holdings")
  fill_in('import_upload_name', with: "Test Upload")
  attach_file('import_upload_import_file', File.absolute_path('./public/sample_uploads/holdings.xlsx'))
  click_on("Save")
  sleep(4)
end

Then('There should be {string} holdings created') do |count|
  Holding.count.should == count.to_i
  Holding.all.sum(:quantity).should == 1000
  Holding.all.each do |h|
    h.investor.category.should == h.holding_type
    h.user.entity_id.should == h.investor.investor_entity_id
  end 
end

Then('There should be {string} users created for the holdings') do |count|
  (User.count - @existing_user_count).should == count.to_i
end

Then('There should be {string} Investments created for the holdings') do |count|
  Investment.count.should == count.to_i
end
