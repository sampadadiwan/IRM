Feature: Investor
  Can create and view an investor as a startup

Scenario Outline: Create new investor
  Given Im logged in as a user "<user>" for an entity "<entity>"
  And I am at the investor page
  When I create a new investor "<investor>"
  Then I should see the "<msg>"
  And an investor should be created
  And an investor entity should be created
  And I should see the investor details on the details page

  Examples:
  	|user	      |entity               |investor     |msg	|
  	|  	        |entity_type=Startup  |name=Sequoia |Investor was successfully created|
    |  	        |entity_type=Startup  |name=Bearing |Investor was successfully created|


Scenario Outline: Create new investor from exiting entity
  Given Im logged in as a user "<user>" for an entity "<entity>"
  Given there is an existing investor entity "<investor>"
  And I am at the investor page
  When I create a new investor "<investor>" for the existing invest entity
  Then I should see the "<msg>"
  And an investor should be created
  And an investor entity should not be created
  And I should see the investor details on the details page

  Examples:
  	|user	      |entity               |investor     |msg	|
  	|  	        |entity_type=Startup  |name=Sequoia |Investor was successfully created|
    |  	        |entity_type=Startup  |name=Bearing |Investor was successfully created|
