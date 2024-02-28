Feature: CustomFields
  Test behavior of the CustomFields


Scenario Outline: Create investor kyc - with custom fields as fund
  Given Im logged in as a user "first_name=Test" for an entity "name=Urban;entity_type=Investment Fund"
  Given the user has role "company_admin"
  Given the entity has custom fields "<custom_fields>" for "IndividualKyc" 
  Given there is an existing investor "investor_name=Investor 1"
  Given I create a new InvestorKyc "PAN=ABCD9876F;properties=F3:Test" with files "<files>" for ""
  Then I should see the "Investor kyc was successfully saved. Please upload the required documents for the KYC."
  And I should see the kyc documents "<files>"
  Then I should see the investor kyc details on the details page
  Examples:
    |custom_fields| files |
    |name=F1;field_type=File;required=true#name=F2;field_type=File;required=false#name=F3;field_type=TextField;required=true         | F1,F2|
    |name=F1;field_type=File;required=true#name=F2;field_type=File;required=true#name=F3;field_type=TextField;required=true         | F1,F2|
    |name=F1;field_type=File;required=false#name=F2;field_type=File;required=false#name=F3;field_type=TextField;required=true         | F1|


Scenario Outline: Create investor kyc - with custom fields as investor
  Given there is a user "" for an entity "name=Fund1;entity_type=Investment Fund"
  Given the entity has custom fields "<custom_fields>" for "IndividualKyc" 
  Given there is an existing investor "name=Investor 1" with "1" users 
  Given I login as the investor user
  Given I create a new InvestorKyc "PAN=ABCD9876F;properties=F3:Test" with files "<files>" for "{'investor_kyc[entity_id]': 1, 'investor_kyc[investor_id]': 1}"
  Then I should see the "Investor kyc was successfully saved. Please upload the required documents for the KYC."
  And I should see the kyc documents "<files>"
  Then I should see the investor kyc details on the details page
  Examples:
    |custom_fields| files |
    |name=F1;field_type=File;required=true#name=F2;field_type=File;required=false#name=F3;field_type=TextField;required=true         | Upload PAN Card,Upload Address Proof,Upload Cancelled Cheque,F1,F2|
    |name=F1;field_type=File;required=false#name=F2;field_type=File;required=false#name=F3;field_type=TextField;required=true         | Upload PAN Card,Upload Address Proof,Upload Cancelled Cheque,F1|


