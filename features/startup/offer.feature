Feature: Offer
  Can create and view a offers as a startup employee

Scenario Outline: Create new sale with holdings
  Given there is a user "<user>" for an entity "<entity>"
  Given there is are "2" employee investors
  Given Im logged in as an employee investor
  And there is a holding "quantity=100;investment_instrument=Equity" for each employee investor
  Given there is a sale "<sale>"
  Given I have access to the sale  
  And I am at the sales details page
  Then I should see only my holdings
Examples:
    |user	    |entity               |sale                                     |quantity	|
    |  	        |entity_type=Startup  |name=Grand Sale;visible_externally=true  |100        |
    |  	        |entity_type=Startup  |name=Winter Sale;visible_externally=true |200        |
