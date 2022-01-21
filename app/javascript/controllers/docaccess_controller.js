import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  connect() {


    $( document ).on('turbo:frame-load', function() {
      
      let flag = "disabled";
      let reverse = "";

      $("#email_form_group").toggle();
      $('#doc_access_to_email').prop('disabled', flag);

      $("#doc_access_access_type").on("change", function(){

        $("#category_form_group").toggle();
        $('#doc_access_to_category').prop('disabled', flag);

        $("#email_form_group").toggle();
        $('#doc_access_to_email').prop('disabled', reverse);
        
        console.log("Changed");
        [flag, reverse] = [reverse, flag];

      });
    });
  }

  toggle() {
    console.log("Toggle");    
  }
}
