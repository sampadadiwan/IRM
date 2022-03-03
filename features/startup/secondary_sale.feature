Feature: Secondary Sale
  Can create and view a sale as a startup

Scenario Outline: Create new note
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



Scenario Outline: Create new note
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
