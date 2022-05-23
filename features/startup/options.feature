Feature: Option
  Can create and view esop pools

Scenario Outline: Create Options pool
  Given Im logged in as a user "" for an entity "<entity>"
  And I am at the Option Pools page
  When I create a new esop pool "<option_pool>"
  Then I should see the "Option pool was successfully created."
  And an esop pool should be created
  And I should see the esop pool details on the details page
  And I should see the esop pool in all esop pools page
Examples:
    |entity               |option_pool                                                         |
    |entity_type=Startup  |name=Pool 123;number_of_options=10000;excercise_price_cents=2000  |
    |entity_type=Startup  |name=Pool 567;number_of_options=80000;excercise_price_cents=3000  |



Scenario Outline: Create Options pool
  Given there is a user "" for an entity "<entity>"
  Given a esop pool "<option_pool>" is created with vesting schedule "<schedule>"
  Then an esop pool should be created
  And the corresponding funding round is created for the pool
  And the vesting schedule must also be created
Examples:
    |entity               |option_pool                                                         |schedule      |
    |entity_type=Startup  |name=Pool 123;number_of_options=10000;excercise_price_cents=2000  |12:100        |
    |entity_type=Startup  |name=Pool 567;number_of_options=80000;excercise_price_cents=3000  |12:50,24:50   |
    |entity_type=Startup  |name=Pool 567;number_of_options=80000;excercise_price_cents=3000  |12:20,24:30,36:50   |


Scenario Outline: Create Options pool fails
  Given there is a user "" for an entity "<entity>"
  Given a esop pool "<option_pool>" is created with vesting schedule "<schedule>"
  Then an esop pool should not be created
Examples:
    |entity               |option_pool                                                         |schedule      |
    |entity_type=Startup  |name=Pool 123;number_of_options=10000;excercise_price_cents=2000  |12:80         |
    |entity_type=Startup  |name=Pool 123;number_of_options=10000;excercise_price_cents=2000  |12:20,24:20   |
    |entity_type=Startup  |name=Pool 123;number_of_options=10000;excercise_price_cents=2000  |12:180        |


Scenario Outline: Allocate holdings from pool
  Given Im logged in as a user "first_name=Test" for an entity "name=Urban;entity_type=Startup"
  Given a esop pool "name=Pool 1" is created with vesting schedule "12:20,24:30,36:50"
  And Given I upload a holdings file
  Then I should see the "Import upload was successfully created"
  And the pool granted amount should be "700"


Scenario Outline:  Options vested
  Given there is a user "" for an entity "<entity>"
  Given a esop pool "<option_pool>" is created with vesting schedule "<schedule>"
  Given there are "1" employee investors
  And there is an option holding "orig_grant_quantity=1000;investment_instrument=Options" for each employee investor
  And the option grant date is "<months>" ago
  Then the option pool must have "<option_pool_quantites>"
Examples:
    |entity               |option_pool                            |schedule           | months  | option_pool_quantites | 
    |entity_type=Startup  |name=Pool 123;number_of_options=10000  |12:20,24:30,36:50  | 10      | vested_quantity=0;unvested_quantity=10000;lapsed_quantity=0;excercised_quantity=0;unexcercised_quantity=0         |
    |entity_type=Startup  |name=Pool 123;number_of_options=10000  |12:20,24:30,36:50  | 12      | vested_quantity=200;unvested_quantity=9800;lapsed_quantity=0;excercised_quantity=0;unexcercised_quantity=200         |
    |entity_type=Startup  |name=Pool 567;number_of_options=80000  |12:20,24:30,36:50  | 24      | vested_quantity=500;unvested_quantity=79500;lapsed_quantity=0;excercised_quantity=0;unexcercised_quantity=500         |
    |entity_type=Startup  |name=Pool 567;number_of_options=80000  |12:20,24:30,36:50  | 36      | vested_quantity=1000;unvested_quantity=79000;lapsed_quantity=0;excercised_quantity=0;unexcercised_quantity=1000         |


Scenario Outline:  Options lapsed
  Given there is a user "" for an entity "<entity>"
  Given a esop pool "<option_pool>" is created with vesting schedule "<schedule>"
  Given there are "1" employee investors
  And there is an option holding "orig_grant_quantity=1000;investment_instrument=Options" for each employee investor
  And the option grant date is "<months>" ago
  Then the option pool must have "<option_pool_quantites>"
Examples:
    |entity               |option_pool                 |schedule           | months  | option_pool_quantites |
    |entity_type=Startup  |excercise_period_months=12;number_of_options=10000|12:20,24:30,36:50  | 10      | vested_quantity=0;unvested_quantity=10000;lapsed_quantity=0;excercised_quantity=0;unexcercised_quantity=0             | 
    |entity_type=Startup  |excercise_period_months=12;number_of_options=10000|12:20,24:30,36:50  | 12      | vested_quantity=200;unvested_quantity=9800;lapsed_quantity=1000;excercised_quantity=0;unexcercised_quantity=200           | 
    |entity_type=Startup  |excercise_period_months=24;number_of_options=10000|12:20,24:30,36:50  | 24      | vested_quantity=500;unvested_quantity=9500;lapsed_quantity=1000;excercised_quantity=0;unexcercised_quantity=500           |
    |entity_type=Startup  |excercise_period_months=36;number_of_options=10000|12:20,24:30,36:50  | 36      | vested_quantity=1000;unvested_quantity=9000;lapsed_quantity=1000;excercised_quantity=0;unexcercised_quantity=1000           |


Scenario Outline:  Options Excercised
  Given there is a user "" for an entity "<entity>"
  Given a esop pool "<option_pool>" is created with vesting schedule "<schedule>"
  Given there are "1" employee investors
  And there is an option holding "orig_grant_quantity=1000;investment_instrument=Options" for each employee investor
  And the option grant date is "<months>" ago
  Then when the option is excercised "approved=false"
  And the excercise is approved
  Then the option pool must have "<option_pool_quantites>"


Examples:
    |entity               |option_pool                                      |schedule           | months  | option_pool_quantites |
    |entity_type=Startup  |number_of_options=10000;excercise_period_months=98|12:20,24:30,36:50  | 12      | vested_quantity=200;unvested_quantity=9800;lapsed_quantity=0;excercised_quantity=200;unexcercised_quantity=0           |
    |entity_type=Startup  |number_of_options=10000;excercise_period_months=90|12:20,24:30,36:50  | 24      |vested_quantity=500;unvested_quantity=9500;lapsed_quantity=0;excercised_quantity=500;unexcercised_quantity=0           |
    |entity_type=Startup  |number_of_options=10000;excercise_period_months=98|12:20,24:30,36:50  | 36      |vested_quantity=1000;unvested_quantity=9000;lapsed_quantity=0;excercised_quantity=1000;unexcercised_quantity=0           |
