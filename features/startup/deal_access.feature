Feature: Access
  Can access models as a startup

Scenario Outline: Access Deal employee
  Given there is a user "<user>" for an entity "<entity>"
  And given there is a deal "<deal>" for the entity 
  And I should have access to the deal

  Examples:
  	|user	    |entity               |deal                     |
  	|  	      |entity_type=Startup  |name=Series A;amount=100 |
    |  	      |entity_type=Startup  |name=Series B;amount=120 |


Scenario Outline: Access Deal as Other User
  Given there is a user "<user>" for an entity "<entity>"
  And given there is a deal "<deal>" for the entity 
  Given there is another user "first_name=Investor" for another entity "entity_type=VC"
  And another user "false" have access to the deal

  Examples:
  	|user	    |entity               |deal                     |
  	|  	      |entity_type=Startup  |name=Series A;amount=100 |
    |  	      |entity_type=Startup  |name=Series B;amount=120 |


Scenario Outline: Access Deal as Investor without access
  Given there is a user "<user>" for an entity "<entity>"
  And given there is a deal "<deal>" for the entity 
  Given there is another user "first_name=Investor" for another entity "entity_type=VC"
  And another entity is an investor "category=Lead Investor" in entity
  And another user "false" have access to the deal

  Examples:
  	|user	    |entity               |deal                     |
  	|  	      |entity_type=Startup  |name=Series A;amount=100 |
    |  	      |entity_type=Startup  |name=Series B;amount=120 |


Scenario Outline: Access Deal as Investor with access
  Given there is a user "" for an entity "<entity>"
  And given there is a deal "<deal>" for the entity 
  Given there is another user "first_name=Investor" for another entity "entity_type=VC"
  And another entity is an investor "category=Lead Investor" in entity
  And investor has access right "<access_right>" in the deal
  And another user has investor access "<investor_access>" in the investor
  And another user "<should>" have access to the deal 

  Examples:
  	|should	    |entity               |deal                     | access_right                                      | investor_access |
  	|true  	    |entity_type=Startup  |name=Series A;amount=100 | access_type=Deal;access_to_investor_id=1          | approved=1 |
    |true  	    |entity_type=Startup  |name=Series B;amount=120 | access_type=Deal;access_to_category=Lead Investor | approved=1 |
	  |false      |entity_type=Startup  |name=Series A;amount=100 | access_type=Deal;access_to_investor_id=2          | approved=1 |
    |false      |entity_type=Startup  |name=Series B;amount=120 | access_type=Deal;access_to_category=Co-Investor   | approved=1 |
	  |false      |entity_type=Startup  |name=Series A;amount=100 | access_type=Deal;access_to_investor_id=1          | approved=0 |
    |false      |entity_type=Startup  |name=Series B;amount=120 | access_type=Deal;access_to_category=Lead Investor | approved=0 |



Scenario Outline: Access Deal as Investor without investor access
  Given there is a user "" for an entity "<entity>"
  And given there is a deal "<deal>" for the entity 
  Given there is another user "first_name=Investor" for another entity "entity_type=VC"
  And another entity is an investor "category=Lead Investor" in entity
  And investor has access right "<access_right>" in the deal
  And another user "<should>" have access to the deal 

  Examples:
  	|should	    |entity               |deal                     | access_right     |
  	|false      |entity_type=Startup  |name=Series A;amount=100 | access_type=Deal;access_to_investor_id=1 |
    |false      |entity_type=Startup  |name=Series B;amount=120 | access_type=Deal;access_to_category=Lead Investor |


Scenario Outline: Access Deal as Investor without access right
  Given there is a user "" for an entity "<entity>"
  And given there is a deal "<deal>" for the entity 
  Given there is another user "first_name=Investor" for another entity "entity_type=VC"
  And another entity is an investor "category=Lead Investor" in entity
  And another user has investor access "<investor_access>" in the investor
  And another user "<should>" have access to the deal 

  Examples:
  	|should	    |entity               |deal                     | investor_access     |
  	|false      |entity_type=Startup  |name=Series A;amount=100 | approved=1 |
    |false      |entity_type=Startup  |name=Series B;amount=120 | approved=1 |
