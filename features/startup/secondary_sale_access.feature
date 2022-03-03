Feature: Sale Access
  Can access sale as a startup

Scenario Outline: Access Sale as an employee
  Given there is a user "<user>" for an entity "<entity>"
  Given there is a sale "<sale>"
  And I should have "show" access to the sale "true"
  And I should have "update" access to the sale "true"
  And I should have "destroy" access to the sale "true"

  Examples:
  	|user	    |entity               |sale             |
    |  	        |entity_type=Startup  |name=Grand Sale  |
    |  	        |entity_type=Startup  |name=Winter Sale |


Scenario Outline: Access sale as Other User
  Given there is a user "<user>" for an entity "<entity>"
  Given there is a sale "<sale>"
  Given there is another user "first_name=Investor" for another entity "entity_type=VC"
  And another user should have "show" access to the sale "false"

  Examples:
  	|user	    |entity               |sale             |
    |  	        |entity_type=Startup  |name=Grand Sale  |
    |  	        |entity_type=Startup  |name=Winter Sale |