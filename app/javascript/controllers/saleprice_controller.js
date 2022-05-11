import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {

    this.onChange(null);
    console.log("Sale price javascript loaded");
    $(document).on('turbo:frame-load', function () {
      this.onChange(null);
    });

  }

  onChange(event) {
    console.log("onChange");
    console.log("change");
    let selected = $("#secondary_sale_price_type").val();
    switch (selected) {
      case "Price Range":
        $(".fixed_price_group").hide();
        $(".price_range_group").show();

        break;
      case "Fixed Price":
        $(".fixed_price_group").show();
        $(".price_range_group").hide();

        break;
      default:
    }
  }



  // Prevent form from submitting if required fields are not filled
  checkRequiredFilled(event) {
    
    let required_missing = false;
    $('#secondary_sale_form .required').each(function () {
      if ($(this).val().length == 0) {
        console.log("Its blank");
        $(this).closest('.form-group').addClass('field_with_errors');
        required_missing = true;
      } else {
        $(this).closest('.form-group').removeClass('field_with_errors');
      }
    });

    if(required_missing) {
      event.preventDefault();
    }
  }

  // Clear error css if required field is filled
  addErrorCheck() {
    $('#secondary_sale_form .required').each(function () {
      if ($(this).val().length == 0) {
        console.log("Its blank");
        $(this).closest('.form-group').addClass('field_with_errors');
      } else {
        $(this).closest('.form-group').removeClass('field_with_errors');
      }
    });
  }

}
