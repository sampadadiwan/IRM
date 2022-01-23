import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {

    // Setup the wizard js
    $('#smartwizard').smartWizard({
        theme: 'dots',
    });

    // Hide/Show the search fields based on investor type
    $("#search_user_group").toggle();
    $("#investor_investor_type").on("change", function(){
      console.log("investor_investor_type: change");
      $("#search_entity_group").toggle();
      $("#search_user_group").toggle();
    });

  }
}
