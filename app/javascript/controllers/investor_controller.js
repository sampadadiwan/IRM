//import "typeahead"

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    $(".select2").on('select2:select', function (e) { 
      if(e.params.data.text.length > 1) {
        $("#investor_name_group").hide();
      } else {
        $("#investor_name_group").show();
      }
    });
  }

}


