Feature: Investment
  Can view an investment as a VC

Scenario Outline: Create new investment
  Given Im logged in as a user "first_name=Emp1" for an entity "entity_type=VC"
  Given there are "3" exisiting investments "<investment>" from my firm in startups
  And I am at the investor_entities page
  Then I should not see the entities I have invested in
  
  Examples:
  	|investment                                                                                                                   |msg	|
  	|category=Lead Investor;investment_type=Series A;investment_instrument=Equity;quantity=100;price_cents=1000;investor_id=2     |Investment was successfully created|
    |category=Co-Investor;investment_type=Series B;investment_instrument=Preferred;quantity=80;price_cents=2000;investor_id=2     |Investment was successfully created|


Scenario Outline: Create new investment
  Given Im logged in as a user "first_name=Emp1" for an entity "entity_type=VC"
  Given there are "3" exisiting investments "<investment>" from my firm in startups
  And I have been granted access to the investments
  And I am at the investor_entities page
  Then I should see the entities I have invested in
  
  Examples:
  	|investment                                                                                                                   |msg	|
  	|category=Lead Investor;investment_type=Series A;investment_instrument=Equity;quantity=100;price_cents=1000;investor_id=2     |Investment was successfully created|
    |category=Co-Investor;investment_type=Series B;investment_instrument=Preferred;quantity=80;price_cents=2000;investor_id=2     |Investment was successfully created|
