Feature: Registration
  Registration should work properly

Scenario Outline: User Registration Successfully
  Given there is an unsaved user "<user>" for an entity "<entity>"
  And I am at the registration page
  When I fill and submit the registration page
  Then I should see the "<msg1>"
  Then when I click the confirmation link
  Then I should see the "Your email address has been successfully confirmed."
  Then the user should be confirmed
  And I am at the login page
  When I fill and submit the login page
  Then I should see the "<msg2>"
  Examples:
  	|user		|entity             |msg1											                                              |msg2		  |
  	| 	    |entity_type=VC     |A message with a confirmation link has been sent to your email address.	|Signed in successfully	|
    |       |entity_type=Startup|A message with a confirmation link has been sent to your email address. |Signed in successfully  |
    | 	    |entity_type=VC     |A message with a confirmation link has been sent to your email address.	|Signed in successfully	|

