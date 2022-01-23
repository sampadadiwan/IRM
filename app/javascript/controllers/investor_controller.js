  //import "typeahead"

  import { Controller } from "@hotwired/stimulus"

  export default class extends Controller {
    connect() {
      
      this.setup_company_search();
      console.log("Typeahead: Initialized")
      
    }

    setup_user_search() {
      let users = this.search("users");
      
      // Instantiate the Typeahead UI
      $('#investor_investor_user_name').typeahead(null, {
        display: 'display',
        source: users
      });

      $('#investor_investor_user_name').on('typeahead:select', function(ev, suggestion) {
        console.log(suggestion);
        $("#investor_investor_id").val(suggestion.entity.id);
      });

    }


    setup_company_search() {
      let companies = this.search("companies");
      
      // Instantiate the Typeahead UI
      $('#investor_investor_company_name').typeahead(null, {
        display: 'display',
        source: companies
      });

      $('#investor_investor_company_name').on('typeahead:select', function(ev, suggestion) {
        console.log(suggestion);
        $("#investor_investor_id").val(suggestion.entity.id);
        $("#investor_company_name").val(suggestion.entity.name);
        $("#investor_company_url").val(suggestion.entity.url);
        $("#investor_company_category").val(suggestion.entity.category);
        $("#investor_company_logo_url").val(suggestion.entity.logo_url);
        $("#investor_company_company_type").val(suggestion.entity.company_type);
        $("#investor_company_id").val(suggestion.entity.id);
      });

    }

    search(entity_type) {
      // Instantiate the Bloodhound suggestion engine
      const entities = new Bloodhound({
        datumTokenizer: datum => Bloodhound.tokenizers.whitespace(datum.value),
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        remote: {
          wildcard: '%QUERY',
          url: `/${entity_type}/search.json?query=%QUERY`,
          // Map the remote source JSON array to a JavaScript object array
          transform: response => $.map(response, entity => ({
            display: entity.name,
            entity: entity
          }))
        }
      });

      return entities;
              
    }

  }


  