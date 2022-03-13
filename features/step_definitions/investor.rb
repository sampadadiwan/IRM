Given('I am at the investor page') do
  visit("/investors")
end

When('I create a new investor {string}') do |arg1|
  @investor_entity = FactoryBot.build(:entity, entity_type: "VC")
  key_values(@investor_entity, arg1)
  click_on("New Investor")

  if (Entity.vcs.count > 0)
    first('.select2-container', minimum: 1).click
    find('li.select2-results__option[role="treeitem"]', text: @investor_entity.name).click
  end
  fill_in('investor_investor_name', with: @investor_entity.name)
  select("Founder", from: "investor_category")
  click_on("Save")
end

Then('an investor should be created') do
  @investor = Investor.last
  @investor.investor_name.include?(@investor_entity.name).should == true
  @investor.category.should == "Founder"
end

Then('an investor entity should be created') do
  puts @investor.to_json
  @investor_entity = Entity.find_by(name: @investor.investor_name)
  @investor.investor_name.include?(@investor_entity.name).should == true
  @investor.investor_entity_id.should == @investor_entity.id
  @investor.investee_entity_id.should == @user.entity_id
end

Then('an investor entity should not be created') do
  Entity.where(name: @investor.investor_name).count.should == 1

  @investor_entity.name.include?(@investor_entity.name).should == true
  @investor.investor_entity_id.should == @investor_entity.id
  @investor.investee_entity_id.should == @user.entity_id
end

Then('I should see the investor details on the details page') do
  visit investor_path(@investor)
  expect(page).to have_content(@investor.investor_name)
  expect(page).to have_content(@investor.category)
  expect(page).to have_content(@investor.investee_entity.name)
end

Given('there is an existing investor entity {string} with employee {string}') do |arg1, arg2|

  steps %(
      Given there is an existing investor "#{arg1}"
    )

  @employee_investor = FactoryBot.create(:user, entity: @investor_entity)
  key_values(@employee_investor, arg2)
  @employee_investor.save
  puts "\n####Employee Investor####\n"
  puts @employee_investor.to_json
  @holdings_investor = @employee_investor
end


Given('there is an existing investor {string}') do |arg1|
  steps %(
        Given there is an existing investor entity "#{arg1}"
    )
  @investor = FactoryBot.create(:investor, investor_entity_id: @investor_entity.id, investee_entity_id: @entity.id)
  puts "\n####Investor####\n"
  puts @investor.to_json
end

Given('there are {string} existing investor {string}') do |count, arg1|
  (1..count.to_i).each do 
    steps %(
      Given there is an existing investor "#{arg1}"
    )
  end
end


Given('there is an existing investor entity {string}') do |arg1|
  @investor_entity = FactoryBot.build(:entity, entity_type: "VC")
  key_values(@investor_entity, arg1)
  @investor_entity.save
  puts "\n####Investor Entity####\n"
  puts @investor_entity.to_json
end

When('I create a new investor {string} for the existing investor entity') do |string|
  click_on("New Investor")
  
  fill_in('investor_investor_name', with: @investor_entity.name)
  
  first('.select2-container', minimum: 1).click
  find('li', text: @investor_entity.name).click
  select("Founder", from: "investor_category")
  click_on("Save")
end


Given('Given I upload an investor access file for employees') do
  Sidekiq.redis(&:flushdb)

  visit(investor_path(Investor.first))
  click_on("Employee Investors")
  click_on("Upload Employee Investors")
  fill_in('import_upload_name', with: "Test Upload")
  attach_file('import_upload_import_file', File.absolute_path('./public/sample_uploads/investor_access.xlsx'))
  click_on("Save")
  sleep(4)
end

Then('There should be {string} investor access created') do |count|
  InvestorAccess.count.should == count.to_i
end
