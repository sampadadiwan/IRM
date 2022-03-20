Feature: Investment
  Can create and view an investment as a startup

Scenario Outline: Create new investment
  Given Im logged in as a user "<user>" for an entity "<entity>"
  Given there is an existing investor "<investor>"
  And I am at the investments page
  And I create an investment "<investment>"
  Then I should see the "<msg>"
  And an investment should be created
  And I should see the investment details on the details page
  And I should see the investment in all investments page
  And a holding should be created for the investor  

  Examples:
  	|user	      |entity               |investor     |investment                                                                                                             |msg	|
  	|  	        |entity_type=Startup  |name=Sequoia |category=Lead Investor;investment_instrument=Equity;quantity=100;price_cents=1000;investor_id=3     |Investment was successfully created|
    |  	        |entity_type=Startup  |name=Bearing |category=Co-Investor;investment_instrument=Preferred;quantity=80;price_cents=2000;investor_id=3     |Investment was successfully created|

Scenario Outline: Edit investment
  Given Im logged in as a user "<user>" for an entity "<entity>"
  Given there is an existing investor "<investor>"
  And I am at the investments page
  And I create an investment "<investment>"
  Then I should see the "<msg>"
  And an investment should be created
  And I should see the investment details on the details page
  And when I edit the investment "quantity=200;price_cents=3000"
  And I should see the investment details on the details page
  And a holding should be created for the investor  

  Examples:
  	|user	      |entity               |investor     |investment                                                                                                             |msg	|
  	|  	        |entity_type=Startup  |name=Sequoia |category=Lead Investor;investment_instrument=Equity;quantity=100;price_cents=1000;investor_id=3     |Investment was successfully created|
    |  	        |entity_type=Startup  |name=Bearing |category=Co-Investor;investment_instrument=Preferred;quantity=80;price_cents=2000;investor_id=3     |Investment was successfully created|


Scenario Outline: Create new holding
  Given Im logged in as a user "first_name=Test" for an entity "name=Urban;entity_type=Startup"
  Given there are "2" employee investors
  Given there is a FundingRound "name=Series A"
  And Given I create a holding for each employee with quantity "100"
  Then There should be a corresponding holdings created for each employee
  Then There should be a corresponding investment created


Scenario Outline: Import holding
  Given Im logged in as a user "first_name=Test" for an entity "name=Urban;entity_type=Startup"
  And Given I upload a holdings file
  Then I should see the "Import upload was successfully created"
  Then There should be "4" holdings created
  And There should be "4" users created for the holdings  
  And There should be "4" Investments created for the holdings
  And Investments is updated with the holdings 
