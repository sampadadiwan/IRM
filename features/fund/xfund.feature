Feature: Fund
  Can create and view a fund as a company

Scenario Outline: Create new fund
  Given Im logged in as a user "" for an entity "<entity>"
  Given the user has role "company_admin"
  Given there is an existing investor "" with "1" users  
  And I am at the funds page
  When I create a new fund "<fund>"
  Then I should see the "<msg>"
  And an fund should be created
  Given the investors are added to the fund  
  And I should see the fund details on the details page
  And I should see the fund in all funds page
  And I visit the fund details page
  When I click on fund documents tab
  When I create a new document "name=Quarterly Report" in folder "Data Room"
  And an document should be created
  And an email must go out to the investors for the document
  And the fund document details must be setup right
  And I visit the fund details page
  When I click on fund documents tab
  And I should see the document in all documents page

  Examples:
    |entity                                         |fund                |msg	|
  	|entity_type=Investment Fund;enable_funds=true  |name=Test fund      |Fund was successfully created|
    |entity_type=Investment Fund;enable_funds=true;enable_units=true  |name=Merger Fund;unit_types=Series A,Series B    |Fund was successfully created|


Scenario Outline: View fund with employee access
  Given Im logged in as a user "" for an entity "<entity>"
  Given there is a fund "<fund>" for the entity
  And I am "given" employee access to the fund
  When I am at the fund details page  
  And I should see the fund details on the details page
  And I should see the fund in all funds page

  Examples:
  	|entity                                 |fund                 |msg	|
  	|entity_type=Investment Fund;enable_funds=true;enable_units=true  |name=Test fund      |Fund was successfully created|
    |entity_type=Investment Fund;enable_funds=true;enable_units=true  |name=Merger Fund    |Fund was successfully created|

Scenario Outline: View fund - without employee access
  Given Im logged in as a user "<user>" for an entity "<entity>"
  Given there is a fund "<fund>" for the entity
  And I am "no" employee access to the fund
  When I am at the fund details page  
  Then I should see the "<msg>"

  Examples:
  	|user	    |entity                                 |fund                 |msg	|
  	|  	        |entity_type=Investment Fund;enable_funds=true  |name=Test fund      |Access Denied|
    |  	        |entity_type=Investment Fund;enable_funds=true  |name=Merger Fund    |Access Denied|

  

Scenario Outline: Create new capital commitment
  Given Im logged in as a user "<user>" for an entity "<entity>"
  Given the user has role "company_admin"
  Given there is an existing investor "name=A1" with "2" users
  Given there is an existing investor "name=A2" with "2" users
  Given there is a fund "<fund>" for the entity
  Given the fund has capital commitment template   
  Given the investors are added to the fund  
  When I add a capital commitment "1000000" for investor "A1"
  Then I should see the capital commitment details
  Then the fund total committed amount must be "1000000"
  When I add a capital commitment "1000000" for investor "A2"
  Then I should see the capital commitment details
  Then the fund total committed amount must be "2000000"
  Given each investor has a "verified" kyc linked to the commitment
  And when the capital commitment docs are generated
  Then the generated doc must be attached to the capital commitments

  
  Examples:
  	|user	    |entity                                 |fund                 |msg	|
  	|  	      |entity_type=Investment Fund;enable_funds=true  |name=Test fund      |Fund was successfully created|
    |         |entity_type=Investment Fund;enable_funds=true;enable_units=true  |name=Merger Fund;unit_types=Series A,Series B    |Fund was successfully created|


Scenario Outline: Create new commitment after capital call
  Given Im logged in as a user "" for an entity "<entity>"
  Given the user has role "company_admin"
  Given there is an existing investor "" with "1" users
  Given there is an existing investor "" with "1" users
  Given there is a fund "<fund>" for the entity
  Given the investors are added to the fund  
  Given there are capital commitments of "folio_committed_amount_cents=100000000" from each investor
  Given there is a capital call "<call>"
  Given there is an existing investor "" with "1" users
  Given there is a capital commitment of "folio_committed_amount_cents=100000000" for the last investor 
  Given the investors are added to the fund  
  Then the corresponding remittances should be created
  Then I should see the remittances  
  
Examples:
  	|entity                                 |fund                 | call |
  	|entity_type=Investment Fund;enable_funds=true;currency=INR  |name=Test  | percentage_called=20 |
    |entity_type=Investment Fund;enable_funds=true;enable_units=true;currency=USD  |name=Merger;unit_types=Series A,Series B| percentage_called=20;generate_remittances_verified=true |


Scenario Outline: Create new capital call
  Given Im logged in as a user "" for an entity "<entity>"
  Given the user has role "company_admin"
  Given there is a fund "<fund>" for the entity
  And Given I upload an investors file for the fund  
  Given the fund has capital call template
  Given the investors are added to the fund  
  And Given I upload "capital_commitments.xlsx" file for "Commitments" of the fund
  And Given I upload "account_entries.xlsx" file for Account Entries
  When I create a new capital call "<call>"
  Then I should see the capital call details
  Then when the capital call is approved
  Then the corresponding remittances should be created
  Then I should see the remittances
  And the capital call collected amount should be "0"
  When I mark the remittances as paid
  Then I should see the remittances
  And the capital call collected amount should be "0"
  When I mark the remittances as verified
  Then I should see the remittances
  And the capital call collected amount should be "<collected_amount>"
  And the investors must receive email with subject "Capital Call"
  Given each investor has a "verified" kyc linked to the commitment
  # And when the capital call docs are generated
  # Then the generated doc must be attached to the capital remittances

  
  Examples:
  	|entity                                         |fund                |msg	| call | collected_amount |
  	|entity_type=Investment Fund;enable_funds=true  |name=SAAS Fund;currency=INR      |Fund was successfully created| percentage_called=20;call_basis=Percentage of Commitment | 2120000 |
    |entity_type=Investment Fund;enable_funds=true;enable_units=true;currency=INR  |name=SAAS Fund;unit_types=Series A,Series B    |Fund was successfully created| call_basis=Investable Capital Percentage;amount_to_be_called_cents=10000000 | 28000 |


Scenario Outline: Create new capital distrbution
  Given Im logged in as a user "<user>" for an entity "<entity>"
  Given the user has role "company_admin"
  Given there is an existing investor "" with "2" users
  Given there is an existing investor "" with "2" users
  Given there is a fund "<fund>" for the entity
  Given the investors are added to the fund  
  Given there are capital commitments of "folio_committed_amount_cents=100000000" from each investor
  When I create a new capital distribution "cost_of_investment_cents=10000000;"
  Then I should see the capital distrbution details
  Then when the capital distrbution is approved
  Then I should see the capital distrbution payments generated correctly
  And I should be able to see the capital distrbution payments
  And when the capital distrbution payments are marked as paid
  Then the capital distribution must reflect the payments
  And the investors must receive email with subject "Capital Distribution"
  
  Examples:
  	|user	    |entity                                 |fund                 |msg	|
  	|  	        |entity_type=Investment Fund;enable_funds=true  |name=Test fund      |Fund was successfully created|
    |  	        |entity_type=Investment Fund;enable_funds=true  |name=Merger Fund    |Fund was successfully created|



