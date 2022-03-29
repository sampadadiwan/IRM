Feature: Scenarios
  Can create and view an investment as a startup

Scenario Outline: Investments update funding round and entity
  Given there is a user "first_name=Test" for an entity "entity_type=Startup"
  Given there is are "3" investors
  Given there is a FundingRound "name=Series A"
  Given there are "4" investments "<investment>"
  Given there is a FundingRound "name=Series A"
  Given there are "4" investments "<inv2>"
  And the funding rounds must be updated with the right investment
  And the entity must be updated with the investment  
  And the aggregate investments must be created
  And I clone the actual scenario to "Test Scenario"
  Then the investments must be cloned for the new scenario
  Then the aggregate investments must be cloned for the new scenario
  Then the funding round must not be updated with the investments
  Then the entity must not be updated with the investments
 Examples:
  	|investment                                    | inv2                                           |
  	|investment_instrument=Equity;quantity=100     | investment_instrument=Preferred;quantity=200   |
    |investment_instrument=Preferred;quantity=80   | investment_instrument=Options;quantity=100   |
    |investment_instrument=Options;quantity=50     | investment_instrument=Equity;quantity=300   |
