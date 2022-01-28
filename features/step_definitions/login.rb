

Given(/^I am at the login page$/) do
    visit("/")
  end
  
  When(/^I fill and submit the login page$/) do
    fill_in('user_email', with: @user.email)
    fill_in('user_password', with: @user.email)
    click_on("Log in")
    sleep(1)
  end
  
  When(/^I fill the password incorrectly and submit the login page$/) do
    fill_in('user_email', with: @user.email)
    fill_in('user_password', with: "Wrong pass")
    click_on("Log in")
    sleep(1)
  end