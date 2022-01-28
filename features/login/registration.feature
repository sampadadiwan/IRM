Feature: Registration
  Registration should work properly

Scenario Outline: User Registration Successfully
  Given there is an unsaved user "<user>"
  And I am at the registration page
  When I fill and submit the registration page
  Then I should see the "<msg1>"
  Then when I click the confirmation link
  Then I should see the "Thank you for confirming your email address. Please launch the app and follow the instructions there."
  Then the user should be confirmed
  And I am at the login page
  When I fill and submit the login page
  Then I should see the "<msg2>"
  Examples:
  	|user		     |msg1											|msg2		  |
  	|role=Employee	 |Please check your email for verification link	|Signed in successfully	|
    |role=Employee   |Please check your email for verification link |WelSigned in successfullycome  |
    |role=Employee	 |Please check your email for verification link	|Signed in successfully	|

