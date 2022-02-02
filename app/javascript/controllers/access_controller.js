import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  connect() {

    console.log("Access javascript");

    $( document ).on('turbo:frame-load', function() {
      
      console.log("Access javascript loaded");

      let flag = "disabled";
      let reverse = "";

      $("#category_form_group").toggle();
      $('#access_right_category').prop('disabled', flag);

      $("#access_right_email_or_cat").on("change", function(){

        $("#email_form_group").toggle();
        $('#access_right_email').prop('disabled', flag);

        $("#category_form_group").toggle();
        $('#access_right_category').prop('disabled', reverse);

        
        
        console.log("Changed");
        [flag, reverse] = [reverse, flag];

      });
    });
  }

  toggle() {
    console.log("Toggle");    
  }
}
