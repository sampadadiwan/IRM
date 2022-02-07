Feature: Deal
  Can create and view a deal as a startup

Scenario Outline: Create new deal
  Given Im logged in as a user "<user>" for an entity "<entity>"
  And I am at the deals page
  When I create a new deal "<deal>"
  Then I should see the "<msg>"
  And an deal should be created
  And I should see the deal details on the details page
  And I should see the deal in all deals page

  Examples:
  	|user	    |entity               |deal                     |msg	|
  	|  	        |entity_type=Startup  |name=Series A;amount=100 |Deal was successfully created|
    |  	        |entity_type=Startup  |name=Series B;amount=120 |Deal was successfully created|
