Feature: Secondary Sale
  Can create and view a sale as a startup

Scenario Outline: Create new sale
  Given Im logged in as a user "<user>" for an entity "<entity>"
  And I am at the sales page
  When I create a new sale "<sale>"
  Then I should see the "<msg>"
  And an sale should be created
  And I should see the sale details on the details page
  And I should see the sale in all sales page

  Examples:
  	|user	    |entity               |sale             |msg	|
  	|  	        |entity_type=Startup  |name=Grand Sale  |Secondary sale was successfully created|
    |  	        |entity_type=Startup  |name=Winter Sale |Secondary sale was successfully created|



Scenario Outline: Create new sale and make visible
  Given Im logged in as a user "<user>" for an entity "<entity>"
  And I am at the sales page
  When I create a new sale "<sale>"
  Then I should see the "<msg>"
  And an sale should be created
  And I should see the sale details on the details page
  And when I click the "Make Visible Externally" button
  Then the sale should become externally visible

  Examples:
  	|user	    |entity               |sale             |msg	|
  	|  	        |entity_type=Startup  |name=Grand Sale  |Secondary sale was successfully created|
    |  	        |entity_type=Startup  |name=Winter Sale |Secondary sale was successfully created|



Scenario Outline: Create new sale with holdings
  Given Im logged in as a user "<user>" for an entity "<entity>"
  Given there are "2" employee investors
  And Given I create a holding for each employee with quantity "<quantity>"
  Given there is a sale "<sale>"
  And I am at the sales details page
  Then I should see the holdings
Examples:
    |user	    |entity               |sale             |quantity	|
    |  	        |entity_type=Startup  |name=Grand Sale  |100        |
    |  	        |entity_type=Startup  |name=Winter Sale |200        |
