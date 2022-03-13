import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    
  }

  setCurrencyUnit(event) {
    let units = $("#currency_units").val();
    console.log(`setCurrencyUnit called ${units}`);
    let form = $("#currency_units_form");
    let actionUrl = window.location.href;
    console.log(actionUrl);
    form.attr('action', actionUrl);
    let submit = $(event.target).closest("form").find("input[type='submit']");
    submit.click();
  }
}
