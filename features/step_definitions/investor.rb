Given('I am at the investor page') do
  visit("/investors")
end

When('I create a new investor {string}') do |arg1|
  @investor_entity = FactoryBot.build(:entity, entity_type: "VC")
  key_values(@investor_entity, arg1)
  click_on("New Investor")

  fill_in('investor_investor_entity_name', with: @investor_entity.name)
  select("Founder", from: "investor_category")
  click_on("Save")
end

Then('an investor should be created') do
  @investor = Investor.last
  @investor.investor_name.should == @investor_entity.name
  @investor.category.should == "Founder"
end

Then('an investor entity should be created') do
  @investor_entity = Entity.last
  @investor_entity.name.should == @investor.investor_name
  @investor.investor_entity_id.should == @investor_entity.id
  @investor.investee_entity_id.should == @user.entity_id
end

Then('an investor entity should not be created') do
  Entity.where(name: @investor.investor_name).count.should == 1

  @investor_entity.name.should == @investor.investor_name
  @investor.investor_entity_id.should == @investor_entity.id
  @investor.investee_entity_id.should == @user.entity_id
end

Then('I should see the investor details on the details page') do
  visit investor_path(@investor)
  expect(page).to have_content(@investor.investor_name)
  expect(page).to have_content(@investor.category)
  expect(page).to have_content(@investor.investee_entity.name)
end

Given('there is an existing investor {string}') do |arg1|
  steps %(
        Given there is an existing investor entity "#{arg1}"
    )
  @investor = FactoryBot.create(:investor, investor_entity_id: @investor_entity.id, investee_entity_id: @entity.id)
  puts "\n####Investor####\n"
  puts @investor.to_json
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

  fill_in('investor_investor_entity_name', with: @investor_entity.name)
  sleep(1)
  page.execute_script("$('.tt-suggestion:contains(\"#{@investor_entity.name}\")')[0].click()")
  sleep(1)
  select("Founder", from: "investor_category")
  click_on("Save")
end
