Given('Im logged in as a user {string} for an entity {string}') do |arg1, arg2|
  steps %Q{
    Given there is a user "#{arg1}" for an entity "#{arg2}"
    And I am at the login page
    When I fill and submit the login page
  }
end

  Given(/^I am at the login page$/) do
    visit("/")
  end
  
  When(/^I fill and submit the login page$/) do
    fill_in('user_email', with: @user.email)
    fill_in('user_password', with: "password")
    click_on("Log in")
    sleep(1)
  end
  
  When(/^I fill the password incorrectly and submit the login page$/) do
    fill_in('user_email', with: @user.email)
    fill_in('user_password', with: "Wrong pass")
    click_on("Log in")
    sleep(1)
  end