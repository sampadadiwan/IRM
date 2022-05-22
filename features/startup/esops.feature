Feature: Esop
  Can create and view esop pools

Scenario Outline: Create ESOP pool
  Given Im logged in as a user "" for an entity "<entity>"
  And I am at the Esop Pools page
  When I create a new esop pool "<esop_pool>"
  Then I should see the "Esop pool was successfully created."
  And an esop pool should be created
  And I should see the esop pool details on the details page
  And I should see the esop pool in all esop pools page
Examples:
    |entity               |esop_pool                                                         |
    |entity_type=Startup  |name=Pool 123;number_of_options=10000;excercise_price_cents=2000  |
    |entity_type=Startup  |name=Pool 567;number_of_options=80000;excercise_price_cents=3000  |



Scenario Outline: Create ESOP pool
  Given there is a user "" for an entity "<entity>"
  Given a esop pool "<esop_pool>" is created with vesting schedule "<schedule>"
  Then an esop pool should be created
  And the corresponding funding round is created for the pool
  And the vesting schedule must also be created
Examples:
    |entity               |esop_pool                                                         |schedule      |
    |entity_type=Startup  |name=Pool 123;number_of_options=10000;excercise_price_cents=2000  |12:100        |
    |entity_type=Startup  |name=Pool 567;number_of_options=80000;excercise_price_cents=3000  |12:50,24:50   |
    |entity_type=Startup  |name=Pool 567;number_of_options=80000;excercise_price_cents=3000  |12:20,24:30,36:50   |


Scenario Outline: Create ESOP pool fails
  Given there is a user "" for an entity "<entity>"
  Given a esop pool "<esop_pool>" is created with vesting schedule "<schedule>"
  Then an esop pool should not be created
Examples:
    |entity               |esop_pool                                                         |schedule      |
    |entity_type=Startup  |name=Pool 123;number_of_options=10000;excercise_price_cents=2000  |12:80         |
    |entity_type=Startup  |name=Pool 123;number_of_options=10000;excercise_price_cents=2000  |12:20,24:20   |
    |entity_type=Startup  |name=Pool 123;number_of_options=10000;excercise_price_cents=2000  |12:180        |
