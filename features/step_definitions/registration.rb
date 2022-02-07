  Given(/^I am at the registration page$/) do
    visit("/")
    click_on("Sign up")
  end
  
  When(/^I fill and submit the registration page$/) do
    
    fields = [  "first_name", "last_name", "email", "phone"]
    fields.each do |k|
      fill_in("user_#{k}", with: @user[k])
    end
  
    fill_in("user_password", with: "password")
    fill_in("user_password_confirmation", with: "password")

    find("#register_btn").click
  end
  
  Then(/^when I click the confirmation link$/) do
    @saved_user = User.last
    url = user_confirmation_url(confirmation_token: @saved_user.confirmation_token)
    visit(url)
  end
  
  Then(/^the user should be confirmed$/) do
    @saved_user.reload
    @saved_user.confirmed_at.should_not be_nil
  
  
    fields = [  "first_name", "last_name", "email", "phone"]
    fields.each do |k|
      expect(@user[k]).to eql(@saved_user[k])
    end
  
  end
  