Given(/^there is a user "([^"]*)"$/) do |arg1|
  @user = FactoryBot.build(:user, entity: @entity)
  key_values(@user, arg1)
  @user.save!
  puts "\n####User####\n"
  puts @user.to_json
end

Given('there is a user {string} for an entity {string}') do |arg1, arg2|
  @entity = FactoryBot.build(:entity)
  key_values(@entity, arg2)
  @entity.save
  puts "\n####Entity####\n"
  puts @entity.to_json

  @user = FactoryBot.build(:user, entity: @entity)
  key_values(@user, arg1)
  @user.save!
  puts "\n####User####\n"
  puts @user.to_json
end

Then(/^the email has the profile in the body$/) do
  current_email.body.should include("Profile")
  current_email.body.should include("Known As")
  current_email.body.should include("Role")
end

Given(/^there is an unsaved user "([^"]*)"$/) do |arg1|
  @user = FactoryBot.build(:user)
  key_values(@user, arg1)
  puts "\n####Unsaved User####\n"
  puts @user.to_json
end

Given('there is an unsaved user {string} for an entity {string}') do |arg1, arg2|
  @entity = FactoryBot.create(:entity)
  key_values(@entity, arg2)

  @user = FactoryBot.build(:user, entity: @entity)
  key_values(@user, arg1)
  puts "\n####User####\n"
  puts @user.to_json
end

Then(/^I should see the "([^"]*)"$/) do |arg1|
  expect(page).to have_content(arg1)
end

Given(/^Im a logged in user "([^"]*)"$/) do |arg1|
  steps %(
    Given there is a user "#{arg1}"
    And I am at the login page
    When I fill and submit the login page
  )
end

Given(/^Im logged in$/) do
  steps %(
    And I am at the login page
    When I fill and submit the login page
  )
end

Given(/^the user is logged in$/) do
  steps %(
    And I am at the login page
    When I fill and submit the login page
  )
end

Then(/^he must see the message "([^"]*)"$/) do |arg1|
  expect(page).to have_content(arg1)
end

Then(/^I must see the message "([^"]*)"$/) do |arg1|
  expect(page).to have_content(arg1)
end

When(/^I click "([^"]*)"$/) do |arg1|
  click_on(arg1)
end

Then(/^the user receives an email with "([^"]*)" as the subject$/) do |subject|
  open_email(@user.email)
  expect(current_email.subject).to eq subject
end

Then(/^the user receives an email with "([^"]*)" in the subject$/) do |subject|
  open_email(@user.email)
  expect(current_email.subject).to include subject
end

Then(/^the user receives no email$/) do
  open_email(@user.email)
  expect(current_email).to eq nil
end

Then(/^I should see the all the home page menus "([^"]*)"$/) do |arg1|
  arg1.split(";").each do |menu|
    click_on(menu)
    sleep(0.5)
    page.find(".back-button").click
  end
end

Then(/^I should not see the home page menus "([^"]*)"$/) do |arg1|
  arg1.split(";").each do |menu|
    puts "checking menu #{menu}"
    expect(page).to_not have_content(menu)
  end
end

When(/^I click "([^"]*)" in the side panel$/) do |arg1|
  page.find(".bar-button-menutoggle").click
  sleep(1)
  click_on(arg1)
  sleep(1)
end
