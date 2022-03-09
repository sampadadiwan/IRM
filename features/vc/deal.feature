Feature: Deal
  Can view an deal as a VC

Scenario Outline: View deal without access
  Given Im logged in as a user "first_name=Emp1" for an entity "entity_type=VC"
  Given there are "3" exisiting investments "quantity=100" from my firm in startups
  Given there are "3" exisiting deals "<deal>" with another firm in the startups
  And I am at the deal_investors page
  Then I should not see the deals of the startup
  
  Examples:
  	|deal                                 |
  	|name=Series A;amount_cents=10000     |
    |name=Series A;amount_cents=10000     |


Scenario Outline: View deal without access
  Given Im logged in as a user "first_name=Emp1" for an entity "entity_type=VC"
  Given there are "3" exisiting investments "quantity=100" from my firm in startups
  Given there are "3" exisiting deals "<deal>" with my firm in the startups
  And I am at the deal_investors page
  Then I should not see the deals of the startup
  
  Examples:
  	|deal                                 |
  	|name=Series A;amount_cents=10000     |
    |name=Series A;amount_cents=10000     |


Scenario Outline: View deal with access
  Given Im logged in as a user "first_name=Emp1" for an entity "entity_type=VC"
  Given there are "3" exisiting investments "quantity=100" from my firm in startups
  Given there are "3" exisiting deals "<deal>" with my firm in the startups
  Given I have access to all deals
  And I am at the deal_investors page
  Then I should see the deals of the startup
  
  Examples:
  	|deal                                 |
  	|name=Series A;amount_cents=10000     |
    |name=Series A;amount_cents=10000     |
