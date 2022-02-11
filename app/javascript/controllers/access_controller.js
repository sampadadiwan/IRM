import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {

    console.log("Access javascript");
   
    $(document).on('turbo:frame-load', function () {

      console.log("Access javascript loaded");

      $("#category_form_group").hide();
      $('#access_right_access_to_category').prop('disabled', 'disabled');

      $("#access_right_email_or_cat").on("change", function () {
        console.log("change");
        let selected = $("#access_right_email_or_cat").val();
        switch (selected) {
          case "Specific User":
            // hide category & disable
            $("#category_form_group").hide();
            $('#access_right_access_to_category').prop('disabled', 'disabled');
            // Enable and show email and investor
            $("#email_form_group").show();
            $('#access_right_access_to_email').prop('disabled', "");

            $("#investor_form_group").show();
            $('#access_right_access_to_investor_id').prop('disabled', "");

            break;
          case "All Users for Specific Investor":
            // hide category & disable
            $("#category_form_group").hide();
            $('#access_right_access_to_category').prop('disabled', 'disabled');
            // Enable and show email and investor
            $("#email_form_group").hide();
            $('#access_right_access_to_email').prop('disabled', "disabled");

            $("#investor_form_group").show();
            $('#access_right_access_to_investor_id').prop('disabled', "");

            break;
          case "All Investors of Specific Category":
            // hide category & disable
            $("#category_form_group").show();
            $('#access_right_access_to_category').prop('disabled', '');
            // Enable and show email and investor
            $("#email_form_group").hide();
            $('#access_right_access_to_email').prop('disabled', "disabled");

            $("#investor_form_group").hide();
            $('#access_right_access_to_investor_id').prop('disabled', "disabled");

            break;
          default:
        }
      });
    });

  }

  toggleFields(event) {
    console.log("toggleFields");

  }
}
