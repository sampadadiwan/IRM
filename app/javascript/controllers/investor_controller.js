  //import "typeahead"

  import { Controller } from "@hotwired/stimulus"

  export default class extends Controller {
    connect() {
      
      this.setup_entity_search();
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


    setup_entity_search() {
      let entities = this.search("entities");
      
      // Instantiate the Typeahead UI
      $('#investor_investor_entity_name').typeahead(null, {
        display: 'display',
        source: entities
      });

      $('#investor_investor_entity_name').on('typeahead:select', function(ev, suggestion) {
        console.log(suggestion);
        $("#investor_investor_entity_id").val(suggestion.entity.id);
        $("#investor_entity_name").val(suggestion.entity.name);
        $("#investor_entity_url").val(suggestion.entity.url);
        $("#investor_entity_logo_url").val(suggestion.entity.logo_url);
        $("#investor_entity_entity_type").val(suggestion.entity.entity_type);
        $("#investor_entity_id").val(suggestion.entity.id);
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


  