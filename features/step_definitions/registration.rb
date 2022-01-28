  Given(/^I am at the registration page$/) do
    visit("/")
    click_on("Sign up")
    sleep 1
  end
  
  When(/^I fill and submit the registration page$/) do
    
    fields = [  "user_first_name", "user_last_name", "user_email", "user_phone", "user_password"]
    fields.each do |k|
      fill_in(k, with: @user[k])
      sleep(0.5)
    end
  
    fill_in("user_password", with: @user.email)
    fill_in("user_confirm_password", with: @user.email)

    click_on("Register Account")
  end
  
  Then(/^when I click the confirmation link$/) do
    @saved_user = User.last
    visit("http://localhost:3000/auth/confirmation?config=default&confirmation_token=#{@saved_user.confirmation_token}&redirect_url=#{ENV['REDIRECT_SUCCESSFULL_EMAIL_VERIFICATION']}")
  end
  
  Then(/^the user should be confirmed$/) do
    @saved_user.reload
    @saved_user.confirmed_at.should_not be_nil
  
  
    fields = [  "first_name", "last_name", "email", "phone"]
    fields.each do |k|
      expect(@user[k]).to eql(@saved_user[k])
    end
  
  end
  