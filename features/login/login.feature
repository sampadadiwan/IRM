Feature: Login
  Login should be allowed only if there are valid credentials

Scenario Outline: Login Successfully
  Given there is a user "<user>"
  And I am at the login page
  When I fill and submit the login page
  Then I should see the "<msg>"

  Examples:
  	|user	      			|msg	|
  	|role=Employee  	|Signed in successfully|

Scenario Outline: Login Incorrectly
  Given there is a user "<user>"
  And I am at the login page
  When I fill the password incorrectly and submit the login page
  Then I should see the "<msg>"

  Examples:
  	|user		    |msg	|
  	|role=Employee	|Invalid login credentials|
    
Scenario Outline: Home page menus Admin
  Given there is a care_home "<care_home>" with me as admin "<user>"
  And the care home has no bank account
  And I am at the login page
  When I fill and submit the login page
  Then I should see the all the home page menus "<menus>"

  Examples:
    |care_home     |user                               |menus                |
    |verified=false|role=Admin;phone_verified=false    |Verify Mobile Number;|
    |verified=false|role=Admin;phone_verified=false    |Verify Mobile Number;|

