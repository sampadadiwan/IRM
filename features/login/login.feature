Feature: Login
  Login should be allowed only if there are valid credentials

Scenario Outline: Login Successfully
  Given there is a user "<user>" for an entity "<entity>"
  And I am at the login page
  When I fill and submit the login page
  Then I should see the "<msg>"

  Examples:
  	|user	      			|entity               |msg	|
  	|role=Employee  	|entity_type=VC       |Signed in successfully|
    |role=Employee  	|entity_type=Startup  |Signed in successfully|

Scenario Outline: Login Successfully
  Given there is a user "<user>"
  And I am at the login page
  When I fill and submit the login page
  Then I should see the "<msg>"

  Examples:
  	|user	      			    |msg	|
  	|role=Employee  	    |Signed in successfully|
    |role=Employee  	    |Signed in successfully|


Scenario Outline: Login Incorrectly
  Given there is a user "<user>"
  And I am at the login page
  When I fill the password incorrectly and submit the login page
  Then I should see the "<msg>"

  Examples:
  	|user		        |msg	|
  	|role=Employee	|Invalid Email or password|
    
