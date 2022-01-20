  //import "typeahead"

  import { Controller } from "@hotwired/stimulus"

  export default class extends Controller {
    connect() {
      // this.element.textContent = "Hello Investor!"

      // Instantiate the Bloodhound suggestion engine
      const companies = new Bloodhound({
        datumTokenizer: datum => Bloodhound.tokenizers.whitespace(datum.value),
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        remote: {
          wildcard: '%QUERY',
          url: "/companies/search.json?query=%QUERY",
          // Map the remote source JSON array to a JavaScript object array
          transform: response => $.map(response, company => ({
            display: company.name,
            value: company.id
          }))
        }
      });
      
      // Instantiate the Typeahead UI
      $('#investor_investor_company_name').typeahead(null, {
        display: 'display',
        source: companies
      });

      $('#investor_investor_company_name').on('typeahead:select', function(ev, suggestion) {
        console.log(suggestion);
        $("#investor_investor_id").val(suggestion.value);
      });

      console.log("Typeahead: Initialized")
      
    }
  }


  