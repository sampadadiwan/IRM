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

