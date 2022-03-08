Feature: Deal Investor
  Can create and view a deal investor as a startup

Scenario Outline: Create new deal
  Given Im logged in as a user "<user>" for an entity "<entity>"
  Given there is an existing investor "name=Sequoia"
  And there exists a deal "<deal>" for my startup
  And I visit the deal details page
  When I create a new deal investor "<deal_investor>"
  Then I should see the "<msg>"
  And a deal investor should be created
  And I should see the deal investor details on the details page
  And I should see the deal investor in all deal investors page

  Examples:
  	|user	      |deal_investor              |entity               |deal                             |msg	|
  	|  	        |primary_amount_cents=10000 |entity_type=Startup  |name=Series A;amount_cents=10000 |Deal investor was successfully created|
    |  	        |primary_amount_cents=12000 |entity_type=Startup  |name=Series B;amount_cents=12000 |Deal investor was successfully created|
